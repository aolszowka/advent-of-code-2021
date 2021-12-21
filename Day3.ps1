# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/3
# What is the power consumption of the submarine?

function Get-Report {
    [CmdletBinding()]
    param (
        [string[]]$DiagnosticReports
    )

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

    # Calculate the Gamma and epsilon Rate
    $midPoint = [System.Math]::Floor($DiagnosticReports.Length / 2)
    [System.Text.StringBuilder]$gammaRateString = [System.Text.StringBuilder]::new()
    [System.Text.StringBuilder]$epsilonRateString = [System.Text.StringBuilder]::new()


    for ($i = 0; $i -lt $numberOfBits; $i++) {
        if ($frequencyTable[$i] -gt $midPoint) {
            $gammaRateString.Append('1') | Out-Null
            $epsilonRateString.Append('0') | Out-Null
        }
        else {
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

Get-Report -DiagnosticReports $diagReports -Verbose
