# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/7
# How much fuel must they spend to align to that position?

function Get-FuelCost {
    [CmdletBinding()]
    param (
        [int[]]$CrabPositions
    )
    begin {
        function Get-Median {
            [CmdletBinding()]
            param (
                [int[]]$Values
            )
            begin {
                # Calculate the Median
                $medianValue = 0
                $sortedPositions = $Values | Sort-Object
                if ($sortedPositions.Length % 2) {
                    $medianValue = $sortedPositions[[Math]::Floor($sortedPositions.Length / 2)]
                }
                else {
                    $medianValue = ($sortedPositions[$sortedPositions.Length / 2], $sortedPositions[$sortedPositions.Length / 2 - 1] | Measure-Object -Average).Average
                }

                $medianValue
            }
        }
    }
    process {
        $median = Get-Median -Values $CrabPositions
        $fuelCost = ($CrabPositions | ForEach-Object { [Math]::Abs($median - $_) } | Measure-Object -Sum).Sum
        $fuelCost
    }
}

Get-FuelCost -CrabPositions @()
