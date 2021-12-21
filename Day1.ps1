# Copyright (c) 2021 Ace Olszowka
# How many measurements are larger than the previous measurement?

function Measure-LargerThanPrevious {
    [CmdletBinding()]
    param (
        [int[]]$Inputs
    )
    process {
        $measurementsLargerThanPrevious = 0

        # We special case the first value to do nothing
        Write-Verbose -Message "$($Inputs[0]) (N/A - no previous measurement)"

        # Now enumerate though each one
        for ($i = 1; $i -lt $Inputs.Count; $i++) {
            if ($Inputs[$i] -gt $Inputs[$i - 1]) {
                Write-Verbose -Message "$($Inputs[$i]) (increased)"
                $measurementsLargerThanPrevious++
            }
            elseif ($Inputs[$i] -eq $Inputs[$i - 1]) {
                # The specification didn't say what to do in this scenario? Be silent?
                Write-Verbose "$($Inputs[$i]) (no change)"
            }
            else {
                Write-Verbose -Message "$($Inputs[$i]) (decreased)"
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

Measure-LargerThanPrevious -Inputs $inputValues -Verbose