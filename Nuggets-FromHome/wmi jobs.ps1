Start-Job {dir c:\ -Recurse} -name superfreakfun

Get-Job

Stop-Job -Id 1

help *joB*

Receive-Job -Id 3 -Keep

Get-Job | Remove-Job

##localjobs

Invoke-Command -ScriptBlock { Get-EventLog -LogName Security -Newest 100 }  -asjob -jobname evenloggetter #-ComputerName localhost


gwmi -Class win32_logicaldisk -ComputerName localhost -AsJob

Get-Job -Id 6 | select -ExpandProperty childjobs

Get-Job

Receive-Job  -id 8 | Export-Csv eventlog.csv

notepad.exe eventlog.csv

Import-Csv .\eventlog.csv | FT -GroupBy PSComputerName
Get-Job | Remove-Job

Get-Command -Noun job

Invoke-Command -ScriptBlock { dir c:\ -Recurse } -AsJob -JobName 'recurceC'

stop-job id 2
remove-job -id 12

help Invoke-Command -Parameter jobname

help Start-Job

#Version 3


Invoke-Command -ScriptBlock { Get-EventLog -LogName Security -Newest 100 } -ComputerName localhost -AsJob -JobName dave

get-job -id 10 -IncludeChildJob

get-job -id 10 -ChildJobState Completed

Receive-Job -Id 10

Get-Command -Noun job



