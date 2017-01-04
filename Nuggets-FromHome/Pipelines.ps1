Get-Command -Noun csv
Get-Process | Export-Csv C:\Powershell\proc.csv
Import-Csv C:\Powershell\proc.csv
Get-Process | ConvertTo-Csv | Out-File procs.csv
Get-Service | Export-Csv C:\Powershell\services.csv
notepad.exe C:\Powershell\services.csv

Get-Service | Export-Clixml C:\Powershell\services.xml
notepad.exe C:\Powershell\services.xml
Import-Clixml C:\Powershell\services.xml
Get-Process | Export-Clixml -Path C:\Powershell\proc.xml

Compare-Object -ReferenceObject (Import-Clixml C:\Powershell\proc.xml) -DifferenceObject (Get-Process) -Property name | ConvertTo-Html | Out-File C:\Powershell\diff.html
Iexplore.exe C:\powershell\diff.html
Get-EventLog -LogName Security -Newest 10 | Export-Csv 

