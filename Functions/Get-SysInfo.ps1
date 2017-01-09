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
                                    'FreePercent' = ($disk.freespace / $disk.size * 100)}
                $obj = New-Object -TypeName psobject -Property $props
                Write-Output $obj
            }
        }
    }
    End{}
}