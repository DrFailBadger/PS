update-help -force
Save-Help #update offline pcs.
save-help -DestinationPath "C:\dave"

get-help 
get-help Get-Service -Examples
get-help Get-Command -Examples | more
help get-help -Online #goes to online webpage for the version your using
Get-Service -c localhost
help get-service -par c* #partial paramater, as soon as its unique


###   Start

#updating help
get-help update-help -Detailed
update-help

# Saving and updating help locally
save-help -DestinationPath C:\UAM

Update-Help -SourcePath \\servername\share

# searching help
get-help *variable*
Get-Help about_automatic_variables | more #doesnt work in ise!
Get-Help about_automatic_variables -ShowWindow #doesnt work in ise!
#getting help

help Get-Service -Detailed #params and examples
help Get-Service -Examples #examples
help Get-Service -full # full help: params, examples, notes, input /output types
help Get-Service -Parameter d*

#using help
help Start-Service -Online
help Start-Service -ShowWindow

Get-Service Bi* -ComputerName localhost
Get-Service bi* -ComputerName localhost | Start-Service #input object parameter set
Start-Service -DisplayName 'Background Intelligent Transfer Service' -c localhost #displayname parameter set
Start-Service bi* -computername localhost 

get-help *registry*

Get-Help Select-Object -ShowWindow


help Get-Service -ShowWindow
Get-Service bi* -ComputerName localhost | Select-Object -Property DisplayName,MachineName,Status | Format-List
Get-Help Start-Service -ShowWindow
stop-Service -DisplayName 'Background Intelligent Transfer Service' #displayname parameter set
Start-Service bi* -computername localhost 


