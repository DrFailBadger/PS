##Plan A Value
##Plan B PropertyName

start-Transcript -OutputDirectory C:\Users\David\Documents\GitHub\Nuggets

help Start-Transcript -online
Get-Process | gm

Get-Process | 

help Get-Service -full
Get-Service -name s* | where status -eq running ## move filtering to earliest possible

get-aduser -filter * | Where { $_.displayname -like 'don' } # bad as has a filter in first command
Get-aduser -filter 

help get-aduser -full #filter and examples

##version 4.0 filtering

Get-Service | where {$_.Status -eq 'running'  } ##clipboard it

#(Get-Service).where ({$_.Status -eq 'running'}) #doesnt seem to work
$PSVersionTable

help Stop-Process -full

Get-Process | Stop-Process -WhatIf
Get-Service | GM -MemberType *property

Get-Service | Stop-Process -WhatIf
help Get-EventLog -full
help get-service -full
Select-Object @{label='computername';e={$_.name}} | Get-Service

help get-service -full

get-adcomputer -filter * | Select-Object @{label='computername';e={$_.name}} | Get-Service -name * #took name off the table

help Get-EventLog -full

get-adcomputer -filter * | Select-Object @{label='computername';e={$_.name}} | Get-Service -name * #took name off the table
Get-EventLog -LogName Security -Newest 10 -ComputerName (get-adcomputer -filter * | Select -ExpandProperty name)



-expandproperty #just extracted 4 strings