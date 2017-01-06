Get-Command -Noun *cim*
help Get-CimClass

Get-CimClass -ClassName win32_bios -Namespace root\cimv2 
Get-CimClass -ClassName win32_bios -Namespace root\cimv2 | FL -Property *

Get-CimClass -ClassName win32_bios -Namespace root\cimv2 | select -ExpandProperty cimclassproperties
Get-CimClass -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | select -ExpandProperty cimclassproperties
Get-CimClass -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | select -ExpandProperty cimclassproperties

Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | select * 
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct



Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | select * 
gwmi -Namespace root\securitycenter2 -Class AntiSpywareProduct | select * ##compare cim to wmi
gwmi -Namespace root\securitycenter2 -Class AntiSpywareProduct | gm

Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | gm


Get-CimInstance -ClassName Win32_OperatingSystem | fl *

Get-CimInstance -ClassName Win32_OperatingSystem | select -Property LastBootUpTime

Get-CimInstance -ClassName Win32_OperatingSystem  | gm
Get-CimClass -ClassName Win32_OperatingSystem |select -ExpandProperty cimclassmethods

help Get-CimInstance

Get-CimInstance -ClassName Win32_BIOS -Property serialnumber