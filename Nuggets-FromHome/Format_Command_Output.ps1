Get-Process | Format-Wide

Get-Process | Format-Wide -Property id -Column 6

Get-Process | Format-List

Get-Process | Format-List *

Get-Process | Fl *
notepad
Get-Process -name notepad | fl * #super useful

Get-Process | Format-Table -Property name,id,vm,pm,cpu -AutoSize
Get-Process | ft -Property * -wrap
Get-Process | ft -Property * # matrix


Get-Service | sort status | ft -GroupBy status -Property name, status, DisplayName
Get-Process | ft -Property name,id,@{n='vm(MB)';e={$_.vm /1MB};formatstring='N2';align='right';width=12},@{n='PM(MB)';e={$_.PM /1MB};'formatstring'='N2';'align'='right';width=10}

Get-Process | ft -Property name,id,@{n='vm(MB)';e={$_.vm /1MB};formatstring='N2';align='right';width=12},@{n='PM(MB)';e={$_.PM /1MB};'formatstring'='N2';'align'='right';width=10} -AutoSize | ConvertTo-Html | Out-File processes.html

help Format-Table -Examples

Get-Process | ft -Property name,id,@{n='vm(MB)';e={$_.vm /1MB};formatstring='N2';align='right';width=12},@{n='PM(MB)';e={$_.PM /1MB};'formatstring'='N2';'align'='right';width=10} -AutoSize | gm
Out-Host
Out-File
Out-Printer
Out-String ###format very last thing, can only be used by these 4 commands
###FORMAT  - WRITE



