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
        [System.Collections.Generic.HashSet[string]]$CalledNumbers,
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
        [System.Text.StringBuilder]$bingoCardVisualization = [System.Text.StringBuilder]::new()
        $bingoCardWidth = 5
        # Special case the first element to allow our modulus math to work
        $bingoCardVisualization.Append("$(Format-BingoNumber -CalledNumber $BingoCard[0] -CalledNumbers $CalledNumbers) ") | Out-Null
        for ($i = 1; $i -lt $BingoCard.Length; $i++) {
            if ($i % $bingoCardWidth -eq 0) {
                $bingoCardVisualization.Length = $bingoCardVisualization.Length - 1
                $bingoCardVisualization.AppendLine() | Out-Null
            }
            $bingoCardVisualization.Append("$(Format-BingoNumber -CalledNumber $BingoCard[$i] -CalledNumbers $CalledNumbers) ") | Out-Null
        }

        $bingoCardVisualization.ToString()
    }
}

function Test-BingoCard {
    [CmdletBinding()]
    param (
        [System.Collections.Generic.HashSet[string]]$CalledNumbers,
        [string[]]$BingoCard
    )
    process {
        $bingoCardWidth = 5
        $isBingo = $true
        for ($i = 0; $i -lt $BingoCard.Length; $i++) {
            # Check Horizontal
            if ($i % $bingoCardWidth -eq 0) {
                $isBingo = $true
                for ($j = 0; $j -lt $bingoCardWidth - 1; $j++) {
                    if (-Not($CalledNumbers.Contains($BingoCard[$i + $j]))) {
                        $isBingo = $false
                        break
                    }
                }
                if ($isBingo) {
                    break
                }
            }

            # Check Vertical
            if ($i -lt $bingoCardWidth) {
                $isBingo = $true
                for ($j = 0; $j -lt $BingoCard.Length; $j = $j + $bingoCardWidth) {
                    if (-Not($CalledNumbers.Contains($BingoCard[$i + $j]))) {
                        $isBingo = $false
                        break
                    }
                }
                if ($isBingo) {
                    break
                }
            }
        }

        $isBingo
    }
}

function Invoke-Bingo {
    [CmdletBinding()]
    param (
        [string]$Path
    )

    process {
        $bingoInputs = Get-BingoInputs -Path $Path
        #[System.Collections.Generic.HashSet[string]]$calledNumbers = [System.Collections.Generic.HashSet[string]]::new($bingoInputs.NumbersToCall)

        # Horizitonal Bingo
        [string[]]$numbersToCall = @('7', '4', '9', '5', '11', '17', '23', '2', '0', '14', '21', '24')
        [System.Collections.Generic.HashSet[string]]$calledNumbers = [System.Collections.Generic.HashSet[string]]::new($numbersToCall)
        Out-BingoCard -CalledNumbers $calledNumbers -BingoCard $bingoInputs.BingoCards[2]
        Test-BingoCard -CalledNumbers $numbersToCall -BingoCard $bingoInputs.BingoCards[2]

        # Vertical Bingo
        [string[]]$numbersToCall = @('4', '19', '20', '5', '7')
        [System.Collections.Generic.HashSet[string]]$calledNumbers = [System.Collections.Generic.HashSet[string]]::new($numbersToCall)
        Out-BingoCard -CalledNumbers $calledNumbers -BingoCard $bingoInputs.BingoCards[2]
        Test-BingoCard -CalledNumbers $numbersToCall -BingoCard $bingoInputs.BingoCards[2]
    }
}

Invoke-Bingo -Path $PSScriptRoot\input.txt -Verbose
