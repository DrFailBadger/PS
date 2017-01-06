gwmi -Class win32_logicaldisk 

gwmi -Class win32_logicaldisk -Filter "DriveType='3'"

gwmi -Class win32_logicaldisk | where { $_.drivetype -eq 3 }

gwmi -Class win32_logicaldisk -Filter "Deviceid='c:'"

Get-CimInstance -ClassName Win32_Process -ComputerName dc,client

$cim = New-CimSession win7 -SessionOption (New-CimSessionOption -Protocol Dcom)
Get-CimInstance -ClassName Win32_NTEventlogFile -CimSession $cim

Get-WmiObject -ComputerName localhost -Class win32_nteventlogfile -Filter "Logfilename='Application'" |gm

$eventlog = Get-WmiObject -ComputerName localhost -Class win32_nteventlogfile -Filter "Logfilename='Application'" 
$eventlog.BackupEventlog('c:\text.evt')
$eventlog.ClearEventlog('c:\text1.evt')