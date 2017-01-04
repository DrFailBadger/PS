#Thaler Controller

#Remove-Module vmrun
Import-Module VMRun

$MainDir = "C:\UAM\_MassConversion\New Source\new"
$DoneFolder = "C:\UAM\_MassConversion\Captured\New"
$appvDir = Dir "$MainDir"
[string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"

$DefaultVMXPath = "D:\Windows 7 x86 - Copy\Windows 7 x86\Windows 7 x32.vmx"
$DefaultSnapShotName = "MCTNEW"
$DefaultVMUserName = "Packaging User"
$DefaultVMPassword = "P4ckag!ng"
#$Powershell = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`""
#$program1 = "-executionpolicy bypass -file `"C:\packages\vmscript.ps1`""
$program = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -file "C:\packages\vmscript.ps1"'


#Copy-VMFolder -From "C:\GIT\NSI\Expand\VMScript.ps1" -To "C:\Packages\"

Foreach($Zip in ($appvDir|Where-Object -Property "Extension" -eq ".zip")){

    Write-Host "Starting Conversion for $Zip"

    Start-VMSnapshots -Snapshots revertToSnapshot

    Start-Sleep -seconds 40        
        
    Copy-VMFolder -From "$($Zip.FullName)" -To "C:\Packages\"

    Write-host "Running Powershell / Repackager"

    Invoke-VMProgram -ProgramtoRun $program 
           
    
    $process =$(get-VMRunningProc) |Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
    While($process.count -ne 1  ){
        Start-Sleep -seconds 10 
        $process =$(get-VMRunningProc) |Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
        Write-host "Wait for Repackager to open"
    }

    $process =$(get-VMRunningProc) |Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
    While($process.count -ne 0  ){
        Start-Sleep -seconds 10 
        $process =$(get-VMRunningProc) |Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
        Write-host "Repackager still converting applicaiton please wait"
    }
    Start-Sleep -seconds 30 
    $SetMSI = "C:\Packages\Output\MSI_Package\$($Zip.BaseName).MSI"
    $FileExist = & $VMRunexe -gu "$DefaultVMUserName" -gp "$DefaultVMPassword" fileExistsInGuest "$DefaultVMXPath" "$SetMSI"
    If ($FileExist -eq 'The file exists.'){
        Read-Host 'File Found Click enter to copy'
        Copy-VMFolder -CopySelection GuesttoHost -From "C:\Packages\Output\MSI_Package\$($Zip.BaseName).MSI" -To "$DoneFolder"
    }
    Else {Read-Host 'Waiting copy MSI manually'
    }

    Write-host "$($Zip.BaseName).MSI copied to $DoneFolder" 
  

}