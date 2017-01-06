#wmi & powershell - Ricahrd Siddaway

Get-WmiObject -Class win32_networkadapter

gwmi -Query "references of {win32_networkadapter.deviceId=3} where classdefsonly"
gwmi -Query "associators of {win32_networkadapter.deviceid=3} where resultclass = win32_networkadapterconfiguration" | FL *
gwmi -Query "associators of {win32_networkadapter.deviceid=3} where resultclass = win32_networkadapterconfiguration" | gm



$disk = Get-CimInstance -ClassName Win32_LogicalDisk -KeyOnly
$disk[1].DeviceID

Get-CimAssociatedInstance -InputObject $disk[1].DeviceID -ResultClassName win32_diskpartition | fl *


$service =Get-CimInstance -ClassName Win32_Service -Filter "name='bits'"

Get-CimAssociatedInstance -InputObject $service -Association win32_dependentservice

$service | fl *

gcm -Noun cim*