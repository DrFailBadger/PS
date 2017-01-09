Function get-SysInfo {
    Param(
        [String[]]$ComputerName
    )

    foreach ($comp in $ComputerName) {
         $os = Get-WmiObject -Class Win32_operatingsystem -ComputerName $Comp
         $CS = Get-WmiObject -Class Win32_computersystem -ComputerName $comp
         $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $comp
    

        $props = [ordered]@{'ComputerName' =$Comp
                            'OSversion' = $os.version
                            'SPVersion' = $os.servicepackmajorversion
                            'MFG' = $cs.managacturer
                            'Model' = $cs.model
                            'RAM'= $cs.totalphysicalmemory
                            'BISOSerial' = $bios.serialnumber
                }
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
    }
}