Get-WmiObject -Class win32_serice -Filter "State <> 'Running' ADN Startmode ='Auto'"

Invoke-Command -ComputerName localhost (Get-Content .\computer.txt) -ScriptBlock {Get-WmiObject -Class win32_serice -Filter "State <> 'Running' ADN Startmode ='Auto'"} -AsJob

Get-Job -ID 10 | SELECT -ExpandProperty childjobs
receieve-job 


Invoke-Command -ComputerName $env:COMPUTERNAME (Get-Content .\computer.txt) -ScriptBlock {Get-WmiObject -Class win32_serice -Filter "State <> 'Running' ADN Startmode ='Auto'"} -AsJob | Wait-Job -Any | Receive-Job
help Wait-Job -Full
Invoke-Command -ComputerName dc -ScriptBlock { Get-Process } -AsJob | Wait-Job -state Completed | Receive-Job





