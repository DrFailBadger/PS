$ExampleDriveTypePreference = 'Local'
$ExampleErrorLogFile = 'c:\uam\errors.txt'

Function get-SysInfo {
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername
    )

    Begin{}
    Process{

        foreach ($comp in $ComputerName) {
             $os = Get-WmiObject -Class Win32_operatingsystem -ComputerName $Comp
             $CS = Get-WmiObject -Class Win32_computersystem -ComputerName $comp
             $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $comp
    

            $props = [ordered]@{'ComputerName' =$Comp
                                'OSversion' = $os.version
                                'SPVersion' = $os.servicepackmajorversion
                                'MFG' = $cs.manufacturer
                                'Model' = $cs.model
                                'RAM'= $cs.totalphysicalmemory
                                'BISOSerial' = $bios.serialnumber
                    }
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj
        }
    }
    End{}
}

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
        foreach ($computer in $computername){
                If (Check $computer) {
                    $os =Get-WmiObject -ComputerName $computer -Class Win32_OperatingSystem
                    if ($Logoff) { $arg = 0 }
                    if ($Restart) { $arg = 2 }
                    if ($Shutdown) { $arg = 1 }
                    if ($Poweroff) { $arg = 8 }
                    if ($Force) { $Arg += 4 }
                    Try {
                        $ErrorActionPreference = 'Stop'
                        $os.Win32Shutdown($Arg)
                        $ErrorActionPreference = 'Continue'
                    } Catch {
                        #whatever
                    }
                }
        }
    }
}

function get-DiskSpaceInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   Position=1,
                   HelpMessage='Computername',
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername,

        [Parameter(Position=2)]
        [ValidateSet('Floppy','Local','Optical')]
        [String]$DriveType =  $ExampleDriveTypePreference,

        [String]$ErrorLogFile = $ExampleErrorLogFile
    )
    Begin{
        Remove-Item $ErrorLogFile -ErrorAction SilentlyContinue
    }
    Process{
        foreach ($computer in $computername) {
            $params = @{ 'ComputerName' = $computer;
                         'Class' = 'Win32_LogicalDisk' }
            switch ($DriveType){
                'Local' {$params.add('Filter','DriveType=3')}
                'Floppy' {$params.add('Filter','DriveType=2')}
                'Optical' {$params.add('Filter','DriveType=5')}
                
            }
            Try {
            Get-WmiObject @Params -ErrorAction Stop -ErrorVariable myerr  |
            Select-Object @{n='Drive';e={$_.DeviceID}},
                          @{n='Size';e={"{0:N2}" -f ($_.Size /1GB)}},
                          @{n='FreeSpace';e={"{0:N2}" -f ($_.FreeSpace / 1Gb)}},
                          @{n='FreePercent';e={"{0:N2}" -f ($_.FreeSpace / $_.Size *100)}},
                          PSComputerName
            } Catch {
                $computer | Out-File $ErrorLogFile -Append
                Write-Verbose "Failed to connect to $computer; Error is $myerr"
            } 
        }              
    }
    End{}
}


function check($computer){
    $works =$true
    If(Test-Connection $computer -quiet){
        try{
            gwmi Win32_bios -ComputerName $computer -eq stop
        } catch {
            $works = $false
        }
    }
    return $works

}

Export-ModuleMember -variable ExampleDriveTypePreference, ExampleErrorLogFile -Function get-DiskDetails, set-computerState