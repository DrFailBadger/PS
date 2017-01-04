Get-Command * #all commands on pc not just powershell.
Get-Command -CommandType Alias
Get-Command -CommandType Cmdlet
Get-Command  *service* -CommandType Cmdlet
Get-Command  *service* -CommandType Cmdlet -Module activedirectory
Get-Command  *service* -CommandType Cmdlet -Module activedirectory
Get-Command -Verb get -Noun service
Get-Command -ParameterName computername
