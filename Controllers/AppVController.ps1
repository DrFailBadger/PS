$PackageFolder = "C:\Packages"
$appPathExt = dir -Path $PackageFolder

$appPathExt.FullName

$OutputFolder = "$PackageFolder\OutputFolder"
$Exclusionlist ="$PackageFolder\isrepackager.ini"
$Ism = "$PackageFolder\UAM5.0StdWin7.ism"
$AppVExpanderPS1 = "$PackageFolder\AppVExpander.ps1"

$Repackexe = "C:\Program Files\Repackager\Repack.exe"
$Companyname ='ZZZZZZ'


Foreach($Appv in $appPathExt){

    $split =$Appv.Name.Split("-")
    $Version = $split[1]
    $ProductName = $split[0]           
    $AppVPackagePath =$appv.FullName
    $MSIname = $appV.Name


    Set-Content -Path "$AppVExpanderPS1" -value 'Param(  
     
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".appv")})]  
        [Parameter(Mandatory=$True)]  
        [string]$AppVPackagePath  

    )

Expand-AppvSequencerPackage -AppvPackagePath $AppVPackagePath' -Force


    set-Content -Path "$PackageFolder\Install.cmd" -Value "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file '$AppVExpanderPS1' -AppVPackagePath `"$AppVPackagePath`"" | Out-null
    
    #$installCommand = "`"$Repackexe`" -b `"$ism`" -buildonly -app `"$PackageFolder\install.cmd`" -o `"$OutputFolder`" -of $MSIname -PP $productname -P $Companyname -cf `"$Exclusionlist`" -cs Custom -sb -ms"
    Start-Process "$repackexe" -ArgumentList "-b `"$ism`" -buildonly -app `"$PackageFolder\install.cmd`" -o `"$OutputFolder`" -of $MSIname -PP $productname -P $Companyname -cf `"$Exclusionlist`" -cs Custom -sb -ms"

Start-Sleep -Seconds 20

}