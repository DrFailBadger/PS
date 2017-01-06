gwmi -Class win32_service

gwmi -Class win32_service | where {$_.state -ne 'Running' -and $_.startmode -eq 'Auto'}

gwmi -Class win32_service | where {$_.state -ne 'Running' -and $_.startmode -eq 'Auto'}

gwmi -Class win32_service 

help gwmi -full #filter parameter
gwmi -Class win32_service -Filter "State <> 'Running' and Startmode = 'Auto' and name like 'maps%'"

$wql = 'select * from Win32_LogicalDisk WHERE drivetype =3 '

gwmi -Query $wql

Get-CimInstance Win32_Service -Filter "startmode ='auto' and name like 'maps%' and state <> 'running'"

Get-CimInstance -Query "SELECT * FROM Win32_Service WHERE StartMode = 'auto' and name LIKE 'maps%' AND state <> 'running'"

