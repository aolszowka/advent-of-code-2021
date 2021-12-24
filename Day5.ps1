# Copyright (c) 2021 Ace Olszowka
# https://adventofcode.com/2021/day/5
# At how many points do at least two lines overlap?

function Get-LinePoints {
    [CmdletBinding()]
    param (
        [System.Drawing.Point]$Start,
        [System.Drawing.Point]$End
    )
    process {
        # Vertical Line
        if ($End.X -eq $Start.X) {
            $diff_y = [Math]::Abs($End.Y - $Start.Y)
            $smallest_y = [Math]::Min($End.Y, $Start.Y)
            for ($i = 0; $i -le $diff_y; $i++) {
                [System.Drawing.Point]::new($End.X, $smallest_y + $i)
            }
        }
        # Horiztonal Line
        elseif ($End.Y -eq $Start.Y) {
            $diff_x = [Math]::Abs($Start.X - $End.X)
            $smallest_x = [Math]::Min($Start.X, $End.X)
            for ($i = 0; $i -le $diff_x; $i++) {
                [System.Drawing.Point]::new($smallest_x + $i, $End.Y)
            }
        }
        # Assume Diagonal Line
        else {
            if ($Start.X -gt $End.X) {
                # Swap These
                [System.Drawing.Point]$swap = $End
                $End = $Start
                $Start = $swap
            }
            $steps = $End.X - $Start.X
            $slope = 1
            if ($Start.Y -gt $End.Y) {
                $slope = -1
            }
            for ($i = 0; $i -le $steps; $i++) {
                [System.Drawing.Point]::new($Start.X + $i, $Start.Y + ($i * $slope))
            }
        }
    }
}

function Get-Lines {
    [CmdletBinding()]
    param (
        [string]$Path
    )
    process {
        $rawInputs = Get-Content $Path
        foreach ($rawInputLine in $rawInputs) {
            $splitCoordinates = $rawInputLine.Split('->')

            # Start
            # Now Get the X and Y
            $xyCordinates = $splitCoordinates[0].Split(',')
            [System.Drawing.Point]$StartPoint = [System.Drawing.Point]::new([int]::Parse($xyCordinates[0]), [int]::Parse($xyCordinates[1]))

            # End
            # Now Get the X and Y
            $xyCordinates = $splitCoordinates[1].Split(',')
            [System.Drawing.Point]$EndPoint = [System.Drawing.Point]::new([int]::Parse($xyCordinates[0]), [int]::Parse($xyCordinates[1]))

            # Generate the points for the line
            Get-LinePoints -Start $StartPoint -End $EndPoint
        }
    }
}

function Get-LineOverlap {
    [CmdletBinding()]
    param (
        [System.Drawing.Point[]]$Points
    )
    process {
        [System.Collections.Generic.Dictionary[System.Drawing.Point, int]]$populatedPoints = [System.Collections.Generic.Dictionary[System.Drawing.Point, int]]::new()
        $max_x = 0
        $max_y = 0

        foreach ($point in $Points) {
            $max_x = [Math]::Max($max_x, $point.X)
            $max_y = [Math]::Max($max_y, $point.Y)
            if (-Not($populatedPoints.ContainsKey($point))) {
                $populatedPoints.Add($point, 0)
            }
            $populatedPoints[$point]++
        }

        [PSCustomObject]@{
            PopulatedPoints = $populatedPoints
            Max_X           = $max_x
            Max_Y           = $max_y
        }
        $populatedPoints
    }
}

function Out-VisualizeLines {
    [CmdletBinding()]
    param (
        [System.Collections.Generic.Dictionary[System.Drawing.Point, int]]$PopulatedPoints,
        [int]$Max_X,
        [int]$Max_Y
    )
    process {
        [System.Text.StringBuilder]$visualization = [System.Text.StringBuilder]::new()
        for ($y = 0; $y -le $max_y; $y++) {
            for ($x = 0; $x -le $max_x; $x++) {
                [System.Drawing.Point]$currentPoint = [System.Drawing.Point]::new($x, $y)
                if ($PopulatedPoints.ContainsKey($currentPoint)) {
                    $visualization.Append($PopulatedPoints[$currentPoint]) | Out-Null
                }
                else {
                    $visualization.Append('.') | Out-Null
                }
            }
            $visualization.AppendLine() | Out-Null
        }
        $visualization.ToString()
    }
}

$points = Get-Lines -Path $PSScriptRoot\input.txt
$lineResult = Get-LineOverlap -Points $points
Out-VisualizeLines -PopulatedPoints $lineResult.PopulatedPoints -Max_X $lineResult.Max_X -Max_Y $lineResult.Max_Y

# At how many points do at least two lines overlap?
($lineResult.PopulatedPoints.GetEnumerator() | Select-Object -ExpandProperty Value | Where-Object { $_ -gt 1 } | Measure-Object).Count

# # Testing
# Write-Output "Starting x1"
# Get-LinePoints -Start $([System.Drawing.Point]::new(1, 1)) -End $([System.Drawing.Point]::new(1, 3))
# Write-Output "Starting x1.1"
# Get-LinePoints -End $([System.Drawing.Point]::new(1, 1)) -Start $([System.Drawing.Point]::new(1, 3))

# Write-Output "Starting y1"
# Get-LinePoints -Start $([System.Drawing.Point]::new(9, 7)) -End $([System.Drawing.Point]::new(7, 7))
# Write-Output "Starting y1.1"
# Get-LinePoints -End $([System.Drawing.Point]::new(9, 7)) -Start $([System.Drawing.Point]::new(7, 7))
# Write-Output "Starting y2"
# Get-LinePoints -Start $([System.Drawing.Point]::new(0, 9)) -End $([System.Drawing.Point]::new(2, 9))
# Write-Output "Starting y2.1"
# Get-LinePoints -End $([System.Drawing.Point]::new(0, 9)) -Start $([System.Drawing.Point]::new(2, 9))

# Write-Output "Starting Diag Test 1"
# Get-LinePoints -Start $([System.Drawing.Point]::new(1, 1)) -End $([System.Drawing.Point]::new(9, 9))
# Write-Output "Starting Diag Test 1.1"
# Get-LinePoints -End $([System.Drawing.Point]::new(1, 1)) -Start $([System.Drawing.Point]::new(9, 9))

# Write-Output "Starting Diag Test 2"
# Get-LinePoints -Start $([System.Drawing.Point]::new(5, 5)) -End $([System.Drawing.Point]::new(8, 2))
