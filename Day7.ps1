# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/7
# How much fuel must they spend to align to that position?

function Get-Mean {
    [CmdletBinding()]
    param (
        [int[]]$Values
    )
    begin {
        # Calculate the Mean
        $actualMean = ($Values | Measure-Object -Average).Average
        $ceilingMean = [Math]::Ceiling($actualMean)
        $ceilingMean
    }
}

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

function Get-FuelCostConstant {
    [CmdletBinding()]
    param (
        [int[]]$CrabPositions
    )
    process {
        $median = Get-Median -Values $CrabPositions
        $fuelCost = ($CrabPositions | ForEach-Object { [Math]::Abs($median - $_) } | Measure-Object -Sum).Sum
        $fuelCost
    }
}

function Get-FuelCostWeighted {
    [CmdletBinding()]
    param (
        [int[]]$CrabPositions
    )
    process {
        $mean = Get-Mean -Values $CrabPositions
        $median = Get-Median -Values $CrabPositions

        # Try to divide and conquer
        $bestFuelCost = [int]::MaxValue
        $bestFuelCostDistance = 0

        for ($distance = $mean; $distance -ge $median; $distance--) {
            $fuelCost = ($CrabPositions | ForEach-Object {
                $perCrabMovement = [Math]::Abs($distance - $_)
                [long]$perCrabFuelCost = 0
                for ($i = 1; $i -le $perCrabMovement; $i++) {
                    $perCrabFuelCost = $perCrabFuelCost + $i
                }
                $perCrabFuelCost
            } | Measure-Object -Sum).Sum

            if($fuelCost -lt $bestFuelCost) {
                $bestFuelCost = $fuelCost
                $bestFuelCostDistance = $distance
            }
            else {
                break
            }
            Write-Output "Distance: $distance FuelCost: $fuelCost"
        }
        Write-Output "bestFuelCostDistance: $bestFuelCostDistance FuelCost: $bestFuelCost"
    }
}

#Get-FuelCost -CrabPositions @()
#Get-FuelCostWeighted -CrabPositions @()
Get-FuelCostWeighted -CrabPositions @(16,1,2,0,4,2,7,1,2,14)
