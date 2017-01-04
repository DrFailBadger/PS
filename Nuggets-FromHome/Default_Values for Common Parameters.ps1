Get-EventLog -LogName Application -Newest 10
$PSDefaultParameterValues = @{"Get-EventLog:Newest"=10;}
Get-EventLog -LogName Application


$PSDefaultParameterValues = @{"Get-EventLog:Newest"=10;}
$PSDefaultParameterValues.Remove('get-eventlog:logname')

$PSDefaultParameterValues['disabled'] =$false

$PSDefaultParameterValues.Remove('disabled')



Get-EventLog
