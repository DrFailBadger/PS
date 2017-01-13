
Remove-Module VMRun
Import-Module VMRun

Get-Module VMRun | Select-Object -Property ExportedVariables

$inputfolder = 'C:\mc\input'
$outputfolder = 'C:\mc\OutPut'
Get-RunningVMs
$credPassword = cat C:\uam\username-password-encrypted.txt | convertto-securestring
$cred = Get-Credential
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $DefaultVMUserName, $credPassword

Enable-VMSharedFolder -ShareName 'Input' -pathtoHost $inputfolder -VMXPath $DefaultVMXPath
Enable-VMSharedFolder -ShareName 'Output' -pathtoHost "$outputfolder" -VMXPath $DefaultVMXPath
$creds = Get-Credential -UserName packaging
$Win7PSSession = New-PSSession -Name 'Auto' -ComputerName Win7x64SP1IS1 -Credential 'packaging user'


Test-Connection Win7x64SP1IS1

Enter-PSSession $Win7PSSession

Invoke-Command -Session $Win7PSSession {New-PSDrive -Name l -PSProvider FileSystem -Root '\\vmware-host\Shared Folders\Input'; New-PSDrive -Name m -PSProvider FileSystem -Root '\\vmware-host\Shared Folders\output'}
New-PSDrive -Name t -PSProvider FileSystem -Root '\\vmware-host\Shared Folders\Input'
New-PSDrive -Name R -PSProvider FileSystem -Root '\\vmware-host\Shared Folders\output'

Get-PSSession | Remove-PSSession
