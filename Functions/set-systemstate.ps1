
function set-computerState {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername,

        [Switch]$Force,

        [Parameter(ParameterSetName='Logoff')]
        [Switch]$Logoff,

        [Parameter(ParameterSetName='Restart')]
        [Switch]$Restart,

        [Parameter(ParameterSetName='Shutdown')]
        [Switch]$Shutdown,

        [Parameter(ParameterSetName='Poweroff')]
        [Switch]$Poweroff
    )

    Process {
        foreach ($comptuter in $computername){
            $os =Get-WmiObject -ComputerName $computer -Class Win32_OperatingSystem
            if ($Logoff) { $arg = 0 }
            if ($Restart) { $arg = 2 }
            if ($Shutdown) { $arg = 1 }
            if ($Poweroff) { $arg = 8 }
            if ($Force) { $Arg += 4 }
            $os.Win32Shutdown($Arg)
        }
    }


}