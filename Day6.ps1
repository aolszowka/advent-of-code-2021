# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/6
# How many lanternfish would there be after 80 days?

function New-LanternFish {
    [CmdletBinding()]
    param (
        [int]$RemainingDays
    )
    process {
        [PSCustomObject]@{
            RemainingDays = $RemainingDays
        }
    }
}

function Invoke-Simulation {
    [CmdletBinding()]
    param (
        [int[]]$StartingSchool,
        [int]$SimulationDays
    )
    begin {
        function Out-VisualizeSchool {
            [CmdletBinding()]
            param(
                [PSCustomObject[]]$School
            )
            process {
                [string]::Join(',', $($School | Select-Object -ExpandProperty RemainingDays))
            }
        }
    }
    process {
        [System.Collections.Generic.List[PSCustomObject]]$school = [System.Collections.Generic.List[PSCustomObject]]::new()
        # Initialize our School
        foreach ($fish in $StartingSchool) {
            $school.Add($(New-LanternFish -RemainingDays $fish))
        }

        Write-Verbose -Message "Initial state: $(Out-VisualizeSchool -School $school.ToArray())"
        for ($day = 1; $day -le $SimulationDays; $day++) {
            $newFishToAdd = 0
            foreach($fish in $school) {
                if($fish.RemainingDays -eq 0) {
                    $fish.RemainingDays = 6
                    $newFishToAdd++
                }
                else {
                    $fish.RemainingDays = $fish.RemainingDays - 1
                }
            }

            # Add any new fish at the end of the day
            for ($i = 0; $i -lt $newFishToAdd; $i++) {
                $school.Add($(New-LanternFish -RemainingDays 8))
            }

            Write-Verbose -Message "After $("$day".PadLeft(2)) days: $(Out-VisualizeSchool -School $school.ToArray())"
        }

        Write-Verbose -Message "Total Number of Fish $($school.Count)"
        $school.Count
    }
}

# Sanity Check for Sample Input 18 Days: 26 Fish
# Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 16

#Sanity Check for Sample Input 80 Days: 5934 Fish
#Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 80

# Perform Actual Input 80 Days: ???
$startingSchool = @()
Invoke-Simulation -StartingSchool $startingSchool -SimulationDays 80
