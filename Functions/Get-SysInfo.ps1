﻿Function get-SysInfo {
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

Function get-DiskDetails {
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername
    )

    Begin{}
    Process{

        foreach ($comp in $ComputerName) {
            $Disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $Comp
            foreach ($disk in $disks){
    
                $props = [ordered]@{'ComputerName' =$Comp;
                                    'Drive' = $disk.deviceid;
                                    'FreeSpace' = "{0:N2}" -f ($disk.freespace /1GB);
                                    'Size' = "{0:N2}" -f ($disk.size /1GB);
                                    'FreePercent' = "{0:N2}" -f ($disk.freespace / $disk.size * 100)}
                $obj = New-Object -TypeName psobject -Property $props
                Write-Output $obj
            }
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

            If (Test-Connection -ComputerName -$computer -Quiet){
                $works =$true
                Try {
                    Get-WmiObject -Class Win32_Bios -ErrorAction Stop -ComputerName $computer
                } Catch {
                    $works = $false
                }
            }

            If ($works) {
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
}