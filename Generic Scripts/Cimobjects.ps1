Get-CimClass -classname Win32_service | select -expand cimclassmethods | where name -eq Change | Select -expand parameters

 help New-Item -online
 help Move-Item -Examples
Get-WmiObject win32_*

