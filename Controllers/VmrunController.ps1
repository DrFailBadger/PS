Import-Module vmrun

$DefaultVMUserName = "Packaging User"
$DefaultVMPassword = "P4ckag!ng"

$DefaultSnapShotName = "MCTNEW"
$DefaultVMXPath = "D:\Windows 7 x86 - Copy\Windows 7 x86\Windows 7 x32.vmx"
$VMUserName = "Packaging User"
$VMPassword = "P4ckag!ng"
$SnapShotName = "MCTNEW"
$VMXPath = "D:\Windows 7 x86 - Copy\Windows 7 x86\Windows 7 x32.vmx"
[string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"

$Runpath = "$env:windir\system32\windowspowershell\v1.0\PowerShell.exe"
$program = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$program = '"C:\Windows\System32\cmd.exe" "/k dir C:\"'
$program = "C:\Windows\System32\cmd.exe"
$program = '"C:\Windows\System32\cmd.exe" "/k "C:\packages\install.cmd""'
$program = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -executionpolicy bypass -file "C:\packages\vmscript.ps1"'

$VmBasepath = "C:\packages"
$progparam = "Get-process | export-csv '$VmBasepath\proc.csv'"
$progparam = 'Get-process | export-csv "C:\packages\proc.csv"'
$progparam = "C:\packages\Vmscript.ps1"
$progparam = '/c "C:\packages\install.cmd"'
$progparam = '/k dir C:\'


$program1 = "-executionpolicy bypass -file 'C:\packages\vmscript.ps1'"
$program = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -executionpolicy bypass -file `"C:\packages\vmscript.ps1`""


$Powershell = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`""
$program1 = "-executionpolicy bypass -file `"C:\packages\vmscript.ps1`""

$progparam = "$String $program1"


Invoke-VMCommandBasic -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -executionpolicy bypass -file "C:\packages\vmscript.ps1"'

