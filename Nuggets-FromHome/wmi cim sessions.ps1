Get-WmiObject -ComputerName localhost -class win32_bios 

Get-CimInstance -ComputerName localhost -ClassName win32_bios

gcm -Noun cim*

$member = New-CimSession -ComputerName member.lab.pri ##fqdn


Get-CimSession

$member2 = New-CimSession -ComputerName member

$win7 = New-CimSession -ComputerName win7.lab.pri -SessionOption (New-CimSessionOption -Protocol Dcom)


Get-CimSession | ft
Get-CimInstance -ClassName Win32_OperatingSystem -CimSession $member,$win7 | select PSComputerName,VersionBuildNumber | FT




Get-CimSession | Remove-CimInstance

help Get-CimInstance

help new-CimInstance

