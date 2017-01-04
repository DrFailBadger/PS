Get-Process | Sort-Object -Property WS 
Get-Process | Sort WS -Descending | Select-Object -First 5 |gm
Get-Process | Sort WS  | Select -Last 5 
Get-Process | sort -Property Name,WS |select 

Get-Process | Sort WS -Descending | Select-Object -First 5 -Property Name

Get-Process | Sort WS -Descending | Select-Object -First 5 -Property Name,ws,CPU,Comments,Company
Get-Process | Sort WS -Descending | Select Name,ws,CPU,Comments,Company | gm #selected system diagnostics process
Get-Process | Sort WS -Descending | Select wame,vm,ws,pm #typo still produces the colum

Get-Service | Group-Object status
Get-Service | Group status

Get-Process | Measure-Object -Property ws -Maximum -Minimum -Average -Sum

Get-Process | Measure -Property ws -Max -Min -Average -Sum
Get-Command -Noun object
Get-Process | Select-Object -First 6 | Measure -Property ws -Max -Min -Average -Sum |gm

Get-Process | select -Property * | select -First 1
Get-Process #changes the values
Get-Process | Select-Object -Property name,id,@{name='VM(MB)';expression={$_.vm / 1MB}},@{label='PM(MB)';expression={$_.pm / 1MB}}


Get-Process | Select-Object -Property name,id,@{name='VM(MB)';expression={$_.vm / 1MB -as [int]}},@{label='PM(MB)';expression={$_.pm / 1MB -as [int]}}, cpu


Get-Process | Select-Object -Property name,id,@{n='VM(MB)';e={$_.vm / 1MB -as [int]}},@{l='PM(MB)';e={$_.pm / 1MB -as [int]}}, cpu

help Select-Object -Examples
Get-Process | Select-Object -Property name,id,@{n='VM(MB)';e={$_.vm / 1MB -as [int]}},@{l='PM(MB)';e={$_.pm / 1MB -as [int]}}, cpu
Get-Process | Select-Object -Property Id,
name,
@{
    n='pm(MB)';
    e = {$_.pm /1MB -as [int] } ####lolol formattting
}

Get-Process | select -Property name,id,@{n='vm(MB)';e={$_.vm / 1mb -as [int]} } -First 5

Get-Process | Select-Object -Property name,id,@{n='VM(MB)';e={$psitem.vm / 1MB -as [int]}},@{l='PM(MB)';e={$_.pm / 1MB -as [int]}}, cpu

Get-AppxPackage | select -Property name,packagefullname, dependencies,architecture