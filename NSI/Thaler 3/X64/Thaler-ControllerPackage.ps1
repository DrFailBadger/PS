﻿#Set-ExecutionPolicy Unrestricted -Force
$PackageFolder = "C:\packages"
$ServerAppData = "C:\packages\ServerINIS"
$SeqOutPut = "$PackageFolder\SeqOutput"

If((Test-Path $SeqOutPut) -ne $true){
New-Item -Path $SeqOutPut -ItemType directory
}


$ENVTXT = Get-Content -Path "$PackageFolder\ENV.txt"

Foreach ($TxtItem in $EnvTxt) {
    
    set-Content -Path "$PackageFolder\Install.cmd" -Value "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file `"C:\packages\Thaler Installer.ps1`" -ThalerENV $TxtItem -PackageFolder `"$PackageFolder`" -ServerAppData `"$ServerAppData`"" | Out-null
    New-AppvSequencerPackage -FullLoad -Installer "$PackageFolder\install.cmd" -TemplateFilePath "$PackageFolder\Atos.appvt" -Name "Thaler-3103-AV5-$TxtItem-R01-R01" -Path "$SeqOutPut" -Verbose | Out-Null
   
    Remove-Item "${env:ProgramFiles(x86)}\Thaler" -recurse -Force
    Remove-Item "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Callataÿ & Wouters" -Recurse -Force
    Remove-Item "Registry::HKEY_CURRENT_USER\Software\Callataÿ & Wouters" -Recurse -Force
    Remove-item "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\Thaler.exe" -Recurse -Force
    Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Enterprise Applications" -Recurse -Force

}