Param(
    [Parameter(Mandatory=$true)]
    [string]$ThalerENV
)

$SeqOutPut = "C:\Packages\Thaler\Output"
$PackageFolder = "C:\Packages\Thaler"
set-Content -Path "C:\Packages\Thaler\Install.cmd" -Value "`"C:\Packages\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file `"$PackageFolder\Thaler2-installer.ps1`" -ThalerENV $ThalerENV -PackageFolder `"$PackageFolder`"" | Out-null
New-AppvSequencerPackage -FullLoad -Installer "$PackageFolder\install.cmd" -TemplateFilePath "$PackageFolder\Atos.appvt" -Name "Thaler-3103-AV5-$ThalerENV-63-R01-R01" -Path "$SeqOutPut" -Verbose | Out-Null
