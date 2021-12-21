# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/2
# What do you get if you multiply your final horizontal position by your final depth?

function Invoke-Dive {
    [CmdletBinding()]
    param (
        [string[]]$Commands
    )
    process {
        [System.Drawing.Point]$currentPosition = [System.Drawing.Point]::new(0, 0)

        [int]$aim = 0

        foreach ($command in $Commands) {
            [string[]]$splitCommand = $command.Split(' ')
            [int]$distance = [int]::Parse($splitCommand[1])

            switch ($splitCommand[0]) {
                'forward' {
                    $currentPosition.X += $distance
                    $currentPosition.Y += $aim * $distance
                }
                'down' {
                    $aim = $aim + $distance
                }
                'up' {
                    $aim = $aim - $distance
                }
                Default {
                    Write-Error -Message "Unknown Command $($splitCommand[0])" 
                }
            }

            Write-Verbose -Message "$command - Current Position $($currentPosition.ToString())"
        }

        $finalPosition = $currentPosition.X * $currentPosition.Y
        $finalPosition
    }
}

$commands = @(
    'forward 5',
    'down 5',
    'forward 8',
    'up 3',
    'down 8',
    'forward 2'
)
#$commands = Get-Content "$PSScriptRoot\input.txt"

Invoke-Dive -Commands $commands -Verbose