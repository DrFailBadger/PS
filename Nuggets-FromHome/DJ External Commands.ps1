icacks C:\Powershell\LogFiles\* /grant adminstrator:(d,wdac)

icacls C:\Powershell\LogFiles\* /grant "Administrator:(d,wdac)"

icacls 

icacls --% C:\Powershell\LogFiles\* /grant Administrator:(d,wdac) #--% allows anything after the command

$LASTEXITCODE #lastexit code of any command run


ping localhost

ping nouusu

icacls 
function grant-access{
Param($username)
Icacls $file /grant "$username:(d,wdac)"
}