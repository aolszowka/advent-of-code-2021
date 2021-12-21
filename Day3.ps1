# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/3
# What is the power consumption of the submarine?
# What is the life support rating of the submarine?

function Get-FrequencyTable {
    [CmdletBinding()]
    param (
        [string[]]$DiagnosticReports
    )
    process {
        [System.Collections.Generic.Dictionary[int, int]]$frequencyTable = [System.Collections.Generic.Dictionary[int, int]]::new()

        $numberOfBits = $DiagnosticReports[0].Length
        # Initialize the Table
        for ($i = 0; $i -lt $numberOfBits; $i++) {
            $frequencyTable.Add($i, 0)
        }

        # Load the frequency for the entire report
        foreach ($report in $DiagnosticReports) {
            $index = 0
            foreach ($bit in $report.GetEnumerator()) {
                if ($bit -eq '1') {
                    $frequencyTable[$index] = $frequencyTable[$index] + 1
                }
                $index++
            }
        }

        $frequencyTable
    }
}

function Get-LifeSupport {
    [CmdletBinding()]
    param (
        [string[]]$DiagnosticReports
    )
    begin {
        function Get-OxygenGeneratorRating {
            [CmdletBinding()]
            param (
                [string[]]$DiagnosticReports
            )
            process {
                $currentBit = 0
                [System.Collections.Generic.List[string]]$currentTable = [System.Collections.Generic.List[string]]::new($DiagnosticReports)
                while ($currentTable.Count -gt 1) {
                    $currentMidPoint = $currentTable.Count / 2
                    [System.Collections.Generic.Dictionary[int, int]]$frequencyTable = Get-FrequencyTable -DiagnosticReports $currentTable
                    if ($frequencyTable[$currentBit] -gt $currentMidPoint) {
                        # Then 1 is the most common bit
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 1 })
                        Write-Verbose -Message "1 was the most common bit in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    elseif ($frequencyTable[$currentBit] -lt $currentMidPoint) {
                        # Then 0 is the most common bit
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 0 })
                        Write-Verbose -Message "0 was the most common bit in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    else {
                        # Both 1 and 0 are distributed equality; keep elements with a 1 in this position
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 1 })
                        Write-Verbose -Message "0 and 1 were found equality in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    $currentBit++
                }

                # When you drop out of this table you will have the Oxygen Generator Rating
                [string]$oxygenGeneratorRatingString = $currentTable[0]
                $oxygenGeneratorRating = [System.Convert]::ToInt32($oxygenGeneratorRatingString, 2)

                Write-Verbose -Message "Oxygen Generator Rating $oxygenGeneratorRatingString ($oxygenGeneratorRating)"
                $oxygenGeneratorRating
            }
        }

        function Get-CO2ScrubberRating {
            [CmdletBinding()]
            param (
                [string[]]$DiagnosticReports
            )
            process {
                $currentBit = 0
                [System.Collections.Generic.List[string]]$currentTable = [System.Collections.Generic.List[string]]::new($DiagnosticReports)
                while ($currentTable.Count -gt 1) {
                    $currentMidPoint = $currentTable.Count / 2
                    [System.Collections.Generic.Dictionary[int, int]]$frequencyTable = Get-FrequencyTable -DiagnosticReports $currentTable
                    if ($frequencyTable[$currentBit] -gt $currentMidPoint) {
                        # Then 1 is the most common bit
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 0 })
                        Write-Verbose -Message "1 was the most common bit in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    elseif ($frequencyTable[$currentBit] -lt $currentMidPoint) {
                        # Then 0 is the most common bit
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 1 })
                        Write-Verbose -Message "0 was the most common bit in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    else {
                        # Both 1 and 0 are distributed equality; keep elements with a 1 in this position
                        $elementsRemoved = $currentTable.RemoveAll( { param($element) $element.Substring($currentBit, 1) -ne 0 })
                        Write-Verbose -Message "0 and 1 were found equality in position $currentBit; Removed $elementsRemoved from the current list"
                    }
                    $currentBit++
                }

                # When you drop out of this table you will have the Oxygen Generator Rating
                [string]$co2ScrubberRatingString = $currentTable[0]
                $co2ScrubberRating = [System.Convert]::ToInt32($co2ScrubberRatingString, 2)

                Write-Verbose -Message "CO2 Scrubber Rating $co2ScrubberRatingString ($co2ScrubberRating)"
                $co2ScrubberRating
            }
        }
    }
    process {
        $oxygenGeneratorRating = Get-OxygenGeneratorRating -DiagnosticReports $DiagnosticReports
        $co2ScrubberRating = Get-CO2ScrubberRating -DiagnosticReports $DiagnosticReports

        $lifeSupportRating = $oxygenGeneratorRating * $co2ScrubberRating
        $lifeSupportRating
    }
}

function Get-PowerConsumption {
    [CmdletBinding()]
    param (
        [string[]]$DiagnosticReports
    )
    process {
        $numberOfBits = $DiagnosticReports[0].Length
        [System.Collections.Generic.Dictionary[int, int]]$frequencyTable = Get-FrequencyTable -DiagnosticReports $DiagnosticReports

        # Calculate the Gamma and epsilon Rate
        $midPoint = [System.Math]::Floor($DiagnosticReports.Length / 2)
        [System.Text.StringBuilder]$gammaRateString = [System.Text.StringBuilder]::new()
        [System.Text.StringBuilder]$epsilonRateString = [System.Text.StringBuilder]::new()


        for ($i = 0; $i -lt $numberOfBits; $i++) {
            if ($frequencyTable[$i] -gt $midPoint) {
                # Then 1 is the most common bit
                $gammaRateString.Append('1') | Out-Null
                $epsilonRateString.Append('0') | Out-Null
            }
            else {
                # Then 0 is the most common bit
                $gammaRateString.Append('0') | Out-Null
                $epsilonRateString.Append('1') | Out-Null
            }
        }

        $gammaRate = [System.Convert]::ToInt32($gammaRateString.ToString(), 2)
        $epsilonRate = [System.Convert]::ToInt32($epsilonRateString.ToString(), 2)

        Write-Verbose "Gamma Rate $($gammaRateString.ToString()) ($gammaRate)"
        Write-Verbose "Epsilon Rate $($epsilonRateString.ToString()) ($epsilonRate)"

        $powerConsumption = $gammaRate * $epsilonRate
        $powerConsumption
    }
}

$diagReports = @(
    '00100',
    '11110',
    '10110',
    '10111',
    '10101',
    '01111',
    '00111',
    '11100',
    '10000',
    '11001',
    '00010',
    '01010'
)
#$diagReports = Get-Content "$PSScriptRoot\input.txt"

Get-PowerConsumption -DiagnosticReports $diagReports -Verbose
Get-LifeSupport -DiagnosticReports $diagReports -Verbose
