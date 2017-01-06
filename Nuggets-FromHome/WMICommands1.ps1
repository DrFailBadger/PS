gwmi win32_service | Select * -First 1 #short version
Get-WmiObject -Class win32_service | Select-Object -Property * -First 1


gwmi win32_bios | fl *

gwmi win32_bios 
"dc","member","win7","client" |Out-File computers.txt
Get-Content computers.txt

gwmi win32_bios -ComputerName (Get-Content .\computers.txt) | ft -Property __Server, serialnumber, version -AutoSize
gwmi win32_bios | gm
gwmi win32_bios | fl *

gmwi -class AntiSpywareProduct -Namespace root\Securitycenter2 | ft Displayname, Productstate -AutoSize

gwmi -Class Win32_operatingsystem -Credential 

help gwmi






