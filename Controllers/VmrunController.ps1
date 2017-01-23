Import-Module vmrun

$DefaultVMUserName = "Packaging"
$DefaultVMPassword = "P4ckag!ng"

$defaultSnapshotname = "Sequencer and UEV Template"
$DefaultVMXPath = "D:\Win10x64 1607\Windows 10 x64 1607.vmx"
$VMUserName = "Packaging User"
$VMPassword = "P4ckag!ng"
$SnapShotName = "MCTNEW"

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
$program1 = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -file "C:\packages\vmscript.ps1"'


$Program = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`""
$program1 = '-executionpolicy bypass -file "C:\packages\vmscript.ps1"'

Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -executionpolicy bypass -file "C:\packages\vmscript.ps1"'
Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"' -file 'C:\packages\vmscript.ps1'


<# Working
$program1 = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -file "C:\packages\vmscript.ps1"'
$Program = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`""

Invoke-VMProgram -ProgramtoRun $program -ProgramtoRunParams $program1
#>