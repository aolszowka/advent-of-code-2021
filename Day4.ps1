# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/4
# What will your final score be if you chose that board?

function Get-BingoInputs {
    [CmdletBinding()]
    param (
        [string]$Path
    )
    process {
        [string[]]$inputContent = Get-Content -Path $Path

        # The first line is the numbers to call
        [string[]]$numbersToCall = $inputContent[0].Split(',')

        # The remainder of lines will be bingo cards
        [System.Collections.Generic.List[string[]]]$bingoCards = [System.Collections.Generic.List[string[]]]::new()
        [System.Collections.Generic.List[string]]$currentBingoCard = [System.Collections.Generic.List[string]]::new()
        for ($i = 2; $i -lt $inputContent.Length; $i++) {
            [string]$currentLine = $inputContent[$i]
            if ([string]::IsNullOrWhiteSpace($currentLine)) {
                $bingoCards.Add($currentBingoCard)
                [System.Collections.Generic.List[string]]$currentBingoCard = [System.Collections.Generic.List[string]]::new()
            }
            else {
                foreach ($bingoValue in $currentLine.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)) {
                    $currentBingoCard.Add($bingoValue)
                }
            }
        }

        # Make sure to add the last bingo card in
        $bingoCards.Add($currentBingoCard)

        Write-Verbose -Message "Calling these Numbers ($($numbersToCall.Length)) $numbersToCall"
        Write-Verbose -Message "Found ($($bingoCards.Count)) Bingo Cards"

        [PSCustomObject]@{
            NumbersToCall = [string[]]$numbersToCall
            BingoCards    = [string[][]]$bingoCards.ToArray()
        }
    }
}

function Out-BingoCard {
    [CmdletBinding()]
    param (
        [string[]]$CalledNumbers,
        [string[]]$BingoCard
    )
    begin {
        function Format-BingoNumber {
            param (
                [string]$CalledNumber,
                [System.Collections.Generic.HashSet[string]]$CalledNumbers
            )
            process {
                if ($CalledNumbers.Contains($CalledNumber)) {
                    "($CalledNumber)".PadLeft(4)
                }
                else {
                    $CalledNumber.PadLeft(4)
                }
            }
        }
    }
    process {
        [System.Collections.Generic.HashSet[string]]$calledNumbersLookup = [System.Collections.Generic.HashSet[string]]::new($CalledNumbers)
        [System.Text.StringBuilder]$bingoCardVisualization = [System.Text.StringBuilder]::new()
        $bingoCardWidth = 5
        # Special case the first element to allow our modulus math to work
        $bingoCardVisualization.Append("$(Format-BingoNumber -CalledNumber $BingoCard[0] -CalledNumbers $calledNumbersLookup) ") | Out-Null
        for ($i = 1; $i -lt $BingoCard.Length; $i++) {
            if ($i % $bingoCardWidth -eq 0) {
                $bingoCardVisualization.Length = $bingoCardVisualization.Length - 1
                $bingoCardVisualization.AppendLine() | Out-Null
            }
            $bingoCardVisualization.Append("$(Format-BingoNumber -CalledNumber $BingoCard[$i] -CalledNumbers $calledNumbersLookup) ") | Out-Null
        }

        $bingoCardVisualization.ToString()
    }
}

function Test-BingoCard {
    [CmdletBinding()]
    param (
        [string[]]$CalledNumbers,
        [string[]]$BingoCard
    )
    process {
        $bingoCardWidth = 5
        [System.Collections.Generic.HashSet[string]]$calledNumbersLookup = [System.Collections.Generic.HashSet[string]]::new($CalledNumbers)
        [boolean]$isBingo = $true
        [System.Collections.Generic.LinkedList[string]]$bingoNumbers = [System.Collections.Generic.LinkedList[string]]::new()
        for ($i = 0; $i -lt $BingoCard.Length; $i++) {
            # Check Horizontal
            if ($i % $bingoCardWidth -eq 0) {
                $isBingo = $true
                for ($j = 0; $j -lt $bingoCardWidth; $j++) {
                    $bingoNumbers.Add($BingoCard[$i + $j])
                    if (-Not($calledNumbersLookup.Contains($BingoCard[$i + $j]))) {
                        $isBingo = $false
                        [System.Collections.Generic.LinkedList[string]]$bingoNumbers = [System.Collections.Generic.LinkedList[string]]::new()
                        break
                    }
                }
                if ($isBingo) {
                    break
                }
            }

            # Check Vertical
            if ($isBingo -eq $false -and $i -lt $bingoCardWidth) {
                $isBingo = $true
                for ($j = 0; $j -lt $BingoCard.Length; $j = $j + $bingoCardWidth) {
                    $bingoNumbers.Add($BingoCard[$i + $j])
                    if (-Not($calledNumbersLookup.Contains($BingoCard[$i + $j]))) {
                        $isBingo = $false
                        [System.Collections.Generic.LinkedList[string]]$bingoNumbers = [System.Collections.Generic.LinkedList[string]]::new()
                        break
                    }
                }
                if ($isBingo) {
                    break
                }
            }
        }

        [PSCustomObject]@{
            IsBingo      = $isBingo
            BingoNumbers = $bingoNumbers
            LastCalled = $CalledNumbers[$CalledNumbers.Length-1]
        }
    }
}

function Invoke-Bingo {
    [CmdletBinding()]
    param (
        [string]$Path
    )

    process {
        $bingoInputs = Get-BingoInputs -Path $Path

        $winnerDeclared = $false
        [System.Collections.Generic.List[string]]$calledNumbers = [System.Collections.Generic.List[string]]::new()
        foreach ($calledNumber in $bingoInputs.NumbersToCall) {
            $calledNumbers.Add($calledNumber) | Out-Null
            Write-Verbose -Message "Calling Number $calledNumber"
            Write-Verbose -Message "Called Numbers: $calledNumbers"
            foreach ($bingoCard in $bingoInputs.BingoCards) {
                $cardIsWinner = Test-BingoCard -CalledNumbers $calledNumbers.ToArray() -BingoCard $bingoCard
                if ($cardIsWinner.IsBingo) {
                    Write-Output -InputObject "Bingo Numbers: $($cardIsWinner.BingoNumbers); Last Called: $($cardIsWinner.LastCalled)"
                    Out-BingoCard -CalledNumbers $calledNumbers.ToArray() -BingoCard $bingoCard
                    $winnerDeclared = $true
                }
                Write-Verbose -Message ""
                Write-Verbose -Message "Bingo Card is a Winner: $($cardIsWinner.IsBingo)"
                Write-Verbose -Message "`r`n$(Out-BingoCard -CalledNumbers $calledNumbers.ToArray() -BingoCard $bingoCard)"
            }
            if ($winnerDeclared) {
                break
            }
        }

        # # Horizitonal Bingo
        # [string[]]$numbersToCall = @('7', '4', '9', '5', '11', '17', '23', '2', '0', '14', '21', '24')
        # [System.Collections.Generic.HashSet[string]]$calledNumbers = [System.Collections.Generic.HashSet[string]]::new($numbersToCall)
        # Out-BingoCard -CalledNumbers $calledNumbers -BingoCard $bingoInputs.BingoCards[2]
        # Test-BingoCard -CalledNumbers $numbersToCall -BingoCard $bingoInputs.BingoCards[2]

        # # Vertical Bingo
        # [string[]]$numbersToCall = @('4', '19', '20', '5', '7')
        # [System.Collections.Generic.HashSet[string]]$calledNumbers = [System.Collections.Generic.HashSet[string]]::new($numbersToCall)
        # Out-BingoCard -CalledNumbers $calledNumbers -BingoCard $bingoInputs.BingoCards[2]
        # Test-BingoCard -CalledNumbers $numbersToCall -BingoCard $bingoInputs.BingoCards[2]
    }
}

Remove-Item output.txt
Start-Transcript -Path output.txt
Invoke-Bingo -Path $PSScriptRoot\input.txt #-Verbose
Stop-Transcript
