$MainDir = "C:\MCT\Zip\NS&I1"
$DoneFolder = "C:\MCT\Captured"
$appvDir = Dir "$MainDir"

$davesCapScript = "MainDir\Daves.Ps1"
$VMname = 'Windows 7 x32.vmx'
$BaseBuild = "D:\Windows 7 x86 - Copy\Windows 7 x86\Windows 7 x32.vmx"
$Snapshot = "MCTNEW"
$VMUserName = "Packaging User"
$VMPassword = "P4ckag!ng"


Function VMCopy-Folder{
    [CmdletBinding()]
    Param(       
                       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})] 
        [Alias('Path')]
        [String]$RunningVM,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "User Name for Target VMX")]
        [String]$VMUserName = "Packaging User",

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Password for Target VMX")]
        [String]$VMPassword = "P4ckag!ng",

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of file")]
        #[ValidateScript({(Test-Path $_)})] 
        [Alias('PathFrom')]
        [String]$From,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of Folder")]
        [Alias('PathTo')]
        [String]$To
        )

$filename = Split-path "$from" -Leaf
IF(Test-Path "$From"){


#& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" createDirectoryInGuest "$RunningVM" "$To"
& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" copyFileFromHostToGuest "$RunningVM" "$from" "$To\$filename"




}else{
#& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" createDirectoryInGuest "$RunningVM" "$To"
& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" copyFileFromGuestToHost "$RunningVM" "$from" "$To\$filename"
}


}

Function Start-VMSnapshots{
    [CmdletBinding()]
    Param(       
                       
        [Parameter(Mandatory=$false,
                   HelpMessage = "-snapshots CreatesSnapshot, DeleteSnapshot,RevertSnapshot")]
        [ValidateSet('CreateSnapshot','DeleteSnapshot','revertToSnapshot')]
        [String]$Snapshots,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
       # [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})]
        [Alias('Path')]
        [String]$VMXpath,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Snapshotnames")]
        #[ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})] 
        [Alias('Name')]
        [String]$SnapshotName

    )
    BEGIN { Write-Verbose "Beginning!" }
    PROCESS {

   [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
       

    Switch($Snapshots) {
        'CreateSnapshot' { 
           $Snapshots1 = "snapshot"
         }
        'DeleteSnapshots' {
           $Snapshots1 = "deleteSnapshot"
         }
        'RevertToSnapshot' {
           $Snapshots1= "revertToSnapshot"
         }
      }

    & "$VMRunexe" -t ws "$Snapshots1" "$vmxPath" "$SnapshotName"
    & "$VMRunexe" -t ws start "$vmxPath"
    }
    END{}

}


Foreach($Zip in ($appvDir|Where-Object -Property "Extension" -eq ".zip")){

    Write-Host "Starting Conversion for $Zip"

    Start-VMSnapshots -Snapshots revertToSnapshot -VMXpath "$BaseBuild" -SnapshotName "$Snapshot"

    #Write-Host "Reverting $VMname to Snapshot - $Snapshot"


    VMCopy-Folder -RunningVM "$BaseBuild" -VMUserName $VMUserName -VMPassword $VMPassword -From "$($Zip.FullName)" -To "C:\Packages\"

    Write-Host "Running Powershell / Repackager"

    & "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -t ws -GU 'Packaging user' -gp 'P4ckag!ng' runPrograminGuest "$BaseBuild" -activeWindow -interactive 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -file 'C:\packages\vmscript.ps1' 
     
 
    $process = $(& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" listProcessesInGuest "$BaseBuild")|Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
    While($process.count -ne 1  ){
        Start-Sleep -seconds 10
        $process = $(& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" listProcessesInGuest "$BaseBuild")|Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
        write-host "Wait for Repackager to open"
    }

    $process = $(& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" listProcessesInGuest "$BaseBuild")|Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
    While($process.count -ne 0  ){
        Start-Sleep -seconds 10
        $process = $(& "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" listProcessesInGuest "$BaseBuild")|Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}
        write-host "Repackager still converting applicaiton please wait"
    }

    VMCopy-Folder -RunningVM "$BaseBuild" -VMUserName $VMUserName -VMPassword $VMPassword -From "C:\Packages\Output\MSI_Package\$($Zip.BaseName).MSI" -To "$DoneFolder"

    Write-Host "$($Zip.BaseName).MSI copied to $DoneFolder" 
  

}



