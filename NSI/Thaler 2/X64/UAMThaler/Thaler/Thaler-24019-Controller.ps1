Param(
    [Parameter(Mandatory=$true)]
    [string]$ThalerENV,
    [Parameter(Mandatory=$True)]
    [string]$ServerAppData = '\\netappnsi01a\appvapps\appdata',
    [Parameter(Mandatory=$true)]
    [string]$ThalerVersion

    
)

$SeqOutPut = "C:\Packages\Thaler\Output"
$PackageFolder = "C:\Packages\Thaler"
set-Content -Path "C:\Packages\Thaler\Install.cmd" -Value "`"C:\Packages\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file `"$PackageFolder\Thaler-$ThalerVersion-installer.ps1`" -ThalerENV $ThalerENV -PackageFolder `"$PackageFolder`" -ServerAppData `"$ServerAppData`"" | Out-null
New-AppvSequencerPackage -FullLoad -Installer "$PackageFolder\install.cmd" -TemplateFilePath "$PackageFolder\Atos.appvt" -Name "Thaler-$ThalerVersion-AV5-$ThalerENV-63-R01-R01" -Path "$SeqOutPut" -Verbose | Out-Null
