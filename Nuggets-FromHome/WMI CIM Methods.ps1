$disk = Get-WmiObject -Class win32_logicaldisk -Filter "deviceid='c:'"
$disk | gm

$disk.VolumeName ='Dave'

$disk.put()

$os | fl *
$os.ConvertFromDateTime($os.LastBootUpTime)

$os | gm
$os = Get-WmiObject -Class win32_operatingsystem
$os.Win32Shutdown(4) # shuts pc down

gwmi win32_service -Filter "name='bits'"| select __server,name

gwmi win32_service -Filter "name='bits'" | gm
gwmi win32_service -Filter "name='bits'" | Invoke-WmiMethod -name startservice

gwmi win32_service -Filter "name='bits'" | invoke-WmiMethod -name stopservice

Invoke-WmiMethod -Class win32_service -ComputerName localhost -name startservice #doesnt work

Get-WmiObject -Class win_32service | Invoke-WmiMethod -name change -ArgumentList 

Get-WmiObject -Class win_32service -Filter "name='bits'" | ForEach-Object { $_.change($null,$Null,$null,$null,$null,$null,$null,'Password') } 


###CIM COMMANDS

$os = Get-CimInstance -ClassName Win32_OperatingSystem 

Get-CimInstance -ClassName Win32_Service -Filter "name'bits'" | Invoke-CimMethod -MethodName change -Arguments @{StartPassword='password'}



