Get-Module -ListAvailable | FW
Import-Module PSScheduledJob
Get-Command -module PSScheduledJob


help New-JobTrigger -Full


$trigger = New-JobTrigger -AtLogOn

help Register-ScheduledJob

help New-ScheduledJobOption -full

$option = New-ScheduledJobOption -RequireNetwork -WakeToRun
help Register-ScheduledJob

Register-ScheduledJob -name "get processes at logon" -ScriptBlock { Get-Process} -MaxResultCount 2 -Trigger $trigger -ScheduledJobOption $option

Get-ScheduledJob | fl *

Get-ScheduledJob | select -ExpandProperty jobtriggers

help Register-ScheduledJob

Import-Module PSScheduledJob
Get-Job # need import module first


