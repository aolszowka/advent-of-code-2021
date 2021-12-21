# Copyright (c) 2021 Ace Olszowka
# How many measurements are larger than the previous measurement?

function Measure-LargerThanPrevious {
    [CmdletBinding()]
    param (
        [int[]]$Inputs
    )
    process {
        $measurementsLargerThanPrevious = 0
        $slidingWindowSize = 3
        $previousWindowSum = -1
        $firstWindow = $true
        $canWindow = $true

        # Now enumerate though each one
        for ($i = 0; $i -lt $Inputs.Count; $i++) {
            $currentWindowSum = 0
            for ($j = 0; $j -lt $slidingWindowSize; $j++) {
                if ($i + $j -lt $Inputs.Count) {
                    $currentWindowSum += $Inputs[$i + $j]
                }
                else {
                    $canWindow = $falses
                }
            }

            if ($canWindow) {
                if ($firstWindow) {
                    $firstWindow = $false
                    Write-Verbose -Message "$([Char]($i + 65)): $currentWindowSum (N/A - no previous sum)"
                }
                elseif ($currentWindowSum -gt $previousWindowSum) {
                    Write-Verbose -Message "$([Char]($i + 65)): $currentWindowSum (increased)"
                    $measurementsLargerThanPrevious++
                }
                elseif ($currentWindowSum -eq $previousWindowSum) {
                    Write-Verbose "$([Char]($i + 65)): $currentWindowSum (no change)"
                }
                else {
                    Write-Verbose -Message "$([Char]($i + 65)): $currentWindowSum (decreased)"
                }

                $previousWindowSum = $currentWindowSum
            }
        }

        $measurementsLargerThanPrevious
    }
}

$inputValues = @(
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263
)
#$inputValues = Get-Content -Path "$PSScriptRoot\input.txt"

Measure-LargerThanPrevious -Inputs $inputValues -Verbose