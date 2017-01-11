
$Location = "D:\GitPS\PS\NSI\Thaler 2\X64\Thaler"
$DefaultVMUserName = "Packaging User"
$DefaultVMPassword = "P4ckag!ng"
$VMXpath = "D:\Windows 7 x64\Windows 7 x64\Windows 7 x64.vmx"
$Snapshotname = "Auto"
$VMWorkingLocation = "C:\packages"
$ThalerENVTXT = Get-Content "$location\ENV.txt"
$program = '& "C:\Packages\thaler\Thaler2-Controller.ps1" -ThalerENV' + " $ThalerENV"


Foreach ($ThalerENV in $ThalerENVTXT){

    
    #Write-Host "Starting Conversion for $Zip"

    Start-VMSnapshots -Snapshots revertToSnapshot -SnapshotName "$Snapshotname" -VMXpath $VMXpath

    Start-Sleep -seconds 40     


    $SequencerVersion = Invoke-VMPSCommand -VMXpath $VMXpath -Command '
    $Return = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("C:\Program Files\Microsoft Application Virtualization\Sequencer\Sequencer.exe").FileVersion
    ' -PSReturnVariable '$Return' -Visible True -ErrorAction SilentlyContinue


    IF($SequencerVersion -ge 5.0){

        Invoke-VMPSCommand -VMXpath $VMXpath -Command '
        $return = MD "C:\Packages" -erroraction "Silentlycontinue"' -PSReturnVariable '$return'

        Copy-VMFolder -VMXPath $VMXpath -From "$Location\Thaler.zip" -To $VMWorkingLocation


        $VMCommand = 'Add-Type -assembly system.io.compression.filesystem
        [io.compression.zipfile]::ExtractToDirectory("' + "$VMWorkingLocation" + '\Thaler.Zip", "' + "$VMWorkingLocation\Thaler" + '")'

        Invoke-VMPSCommand -VMXpath $VMXpath -Command $VMCommand -PSReturnVariable '$null'

        Invoke-VMPSCommand -VMXpath $VMXpath -Command $program -PSReturnVariable '$Null'
        
        Start-sleep 5

        $VMCommand2 = 'Add-Type -assembly system.io.compression.filesystem
        [io.compression.zipfile]::CreateFromDirectory("' + "$VMWorkingLocation" + '\Thaler\Output","' + "$VMWorkingLocation" + '\Thaler\Output.zip")'

        Invoke-VMPSCommand -VMXpath $VMXpath -Command $VMCommand2 -PSReturnVariable '$null'

        MD "$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Documents" -Force
        MD "$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Installation" -Force
        MD "$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Source" -Force

        Copy-VMFolder -VMXPath $VMXpath -From "$VMWorkingLocation\Thaler\Output.zip" -To "$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Installation" -CopySelection GuesttoHost

        Add-Type -assembly system.io.compression.filesystem
        [io.compression.zipfile]::ExtractToDirectory("$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Installation\output.zip","$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Installation")
        del "$Location\Thaler-3103-AV5-$ThalerENV\R01-R01\Installation\Output.zip"




    }





}










