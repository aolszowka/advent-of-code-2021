# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/6
# How many lanternfish would there be after 80 days?

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
                [System.Collections.Generic.Dictionary[int, long]]$School
            )
            process {
                $fishInState = $School.GetEnumerator() | Where-Object { $_.Value -ne 0 } | ForEach-Object {
                    for ($i = 0; $i -lt $_.Value; $i++) {
                        $_.Key
                    }
                }
                [string]::Join(',', $fishInState)
            }
        }
    }
    process {
        [System.Collections.Generic.Dictionary[int, long]]$school = [System.Collections.Generic.Dictionary[int, long]]::new()
        # No Fish will be greater than 8 days old
        for ($day = 0; $day -lt 9; $day++) {
            $school.Add($day, 0) | Out-Null
        }

        # Initialize our School
        foreach ($fish in $StartingSchool) {
            $school[$fish]++
        }

        Write-Verbose -Message "Initial state: $(Out-VisualizeSchool -School $school)"
        for ($day = 1; $day -le $SimulationDays; $day++) {
            $newFishToAdd = $school[0]
            for ($i = 0; $i -lt 8; $i++) {
                $school[$i] = $school[$i + 1]
            }

            # Add any new fish at the end of the day
            $school[8] = $newFishToAdd
            $school[6] = $school[6] + $newFishToAdd

            if ($VerbosePreference) {
                Write-Verbose -Message "After $("$day".PadLeft(2)) days: $(Out-VisualizeSchool -School $school)"
            }
        }

        $totalNumberOfFish = ($school.GetEnumerator() | Select-Object -ExpandProperty Value | Measure-Object -Sum).Sum
        Write-Verbose -Message "Total Number of Fish $totalNumberOfFish"
        $totalNumberOfFish
    }
}

# Sanity Check for Sample Input 18 Days: 26 Fish
#Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 18 -Verbose

#Sanity Check for Sample Input 80 Days: 5934 Fish
#Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 80

#Sanity Check for Sample Input 256 Days: 26984457539 Fish
#Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 256

# Perform Actual Input 80 Days: ???
$startingSchool = @()
Invoke-Simulation -StartingSchool $startingSchool -SimulationDays 256
