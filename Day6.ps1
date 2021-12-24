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
                [string]::Join(',', $($School))
            }
        }
    }
    process {
        [System.Collections.Generic.List[int]]$school = [System.Collections.Generic.List[int]]::new()
        # Initialize our School
        foreach ($fish in $StartingSchool) {
            $school.Add($fish)
        }

        Write-Verbose -Message "Initial state: $(Out-VisualizeSchool -School $school.ToArray())"
        for ($day = 1; $day -le $SimulationDays; $day++) {
            $newFishToAdd = 0
            for ($i = 0; $i -lt $school.Count; $i++) {
                if ($school[$i] -eq 0) {
                    $school[$i] = 6
                    $newFishToAdd++
                }
                else {
                    $school[$i] = $school[$i] - 1
                }
            }

            # Add any new fish at the end of the day
            for ($i = 0; $i -lt $newFishToAdd; $i++) {
                $school.Add( 8)
            }

            Write-Verbose -Message "After $("$day".PadLeft(2)) days: $(Out-VisualizeSchool -School $school.ToArray())"
        }

        Write-Verbose -Message "Total Number of Fish $($school.Count)"
        $school.Count
    }
}

# Sanity Check for Sample Input 18 Days: 26 Fish
Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 18 -Verbose

#Sanity Check for Sample Input 80 Days: 5934 Fish
Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 80

#Sanity Check for Sample Input 256 Days: 26984457539 Fish
Invoke-Simulation -StartingSchool @(3, 4, 3, 1, 2) -SimulationDays 256

# Perform Actual Input 80 Days: ???
#$startingSchool = @(4,1,1,4,1,1,1,1,1,1,1,1,3,4,1,1,1,3,1,3,1,1,1,1,1,1,1,1,1,3,1,3,1,1,1,5,1,2,1,1,5,3,4,2,1,1,4,1,1,5,1,1,5,5,1,1,5,2,1,4,1,2,1,4,5,4,1,1,1,1,3,1,1,1,4,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,1,1,2,1,1,1,1,1,1,1,2,4,4,1,1,3,1,3,2,4,3,1,1,1,1,1,2,1,1,1,1,2,5,1,1,1,1,2,1,1,1,1,1,1,1,2,1,1,4,1,5,1,3,1,1,1,1,1,5,1,1,1,3,1,2,1,2,1,3,4,5,1,1,1,1,1,1,5,1,1,1,1,1,1,1,1,3,1,1,3,1,1,4,1,1,1,1,1,2,1,1,1,1,3,2,1,1,1,4,2,1,1,1,4,1,1,2,3,1,4,1,5,1,1,1,2,1,5,3,3,3,1,5,3,1,1,1,1,1,1,1,1,4,5,3,1,1,5,1,1,1,4,1,1,5,1,2,3,4,2,1,5,2,1,2,5,1,1,1,1,4,1,2,1,1,1,2,5,1,1,5,1,1,1,3,2,4,1,3,1,1,2,1,5,1,3,4,4,2,2,1,1,1,1,5,1,5,2)
#Invoke-Simulation -StartingSchool $startingSchool -SimulationDays 256
