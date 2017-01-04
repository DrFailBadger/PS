get-command -CommandType Alias
function get-newimages
{
$start =(get-date).AddMonths(-1)
$images = Get-ChildItem -Path $env:USERPROFILE\*.jpg -Recurse
$images | Where-Object LastWriteTime -gt $start
}

Get-Command *images* -CommandType Function
get-newimages
$env:COMPUTERNAME #computername

help Get-Command -Parameter commandtype
Get-Command *proc* -CommandType Cmdlet
get-command p* -CommandType Application
$env:path
Get-Command cl* -CommandType Function



get-verb
#Learn new commandlet
Get-Command -Noun service
help New-Service -ShowWindow

show-command New-Service

New-Service -BinaryPathName c:\system32\notepad.exe -Name np -Description "Notepad add a service" -DisplayName Notepad

Get-Command -Noun service

(Get-WmiObject -Class win32_service -Filter "Name='np'").delete()

Get-Command -CommandType Alias
Get-Alias 
Get-Alias dir
Get-Alias -Definition Get-ChildItem #find the alais for that definition
help New-Alias -ShowWindow
New-Alias np notepad.exe
Export-Alias -Path my-alias.csv np
Import-Alias -Path my-alias.csv
my-alias.csv

Get-Service -Name B*

Get-Command -CommandType Cmdlet -Name microsoft
get-help Get-Command -ShowWindow
Get-Command microsoft* -CommandType Application


Get-Verb copy
Get-Command copy

Get-Help Copy-Item -ShowWindow

Get-Command -CommandType Cmdlet -name copy*
Copy-Item -Path "C:\dave\New" -Destination c:\dave\new1 -Recurse
Get-Alias cd
get-help Set-Location -ShowWindow
Get-Alias dir
get-help Get-ChildItem -ShowWindow

dir -path c:\dave\new1\ -Attributes !directory+Readonly
