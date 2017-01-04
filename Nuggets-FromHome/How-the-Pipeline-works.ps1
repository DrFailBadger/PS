##Plan A Value
##Plan B PropertyName

start-Transcript -OutputDirectory C:\Users\David\Documents\GitHub\Nuggets

help Start-Transcript -online
Get-Process | gm

Get-Process | 

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