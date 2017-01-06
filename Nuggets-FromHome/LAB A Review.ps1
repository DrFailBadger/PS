Consle / ISE
get-module -ListAvailable #list module not installed
module auto disco in PS3

help get-service -Full

    ##Parameter name ~ data

Get-Service [[-Name] <String[]>] #[[-Name] <String[]>]#square brackets around all = optional
Get-Service -DisplayName <String[]> #no [] required parameter.
Get-Service [[-Name] <String[]>] #[[-Name]# Brackets around Name = positional,dont need to use -name
Get-Service [[-Name] <String[]>] #<String[]># <> accepts strings
Get-Service [[-Name] <String[]>] #[]# multiple strings [Array]
##Positional paramters are relative, first positinal parameter we had used
-examples # switch parameters on or off


#5 help gsv
Get-Alias gsv
#6 
Get-EventLog -LogName Security -Newest 10
Set-ItemProperty -Path 
help New-PSDrive

##HASHTABLE
$HT = @{'Key1'='Value1'; 'Key2'='Value2'}
$ht.Key1
Value1

$hs = @'
any text etc
read as one string

'@

dir variables:
Get-Command -noun variable
Remove-Variable 

$email ='don.jones@lab.pri'
$regex = "([a-z]+)\.([a-z]+)@"
$email -match $regex
$Matches

$email -replace $regex,'$2.$1@'

Get-HotFix -ComputerName (get-adcomputer -filter * | select -expand name)

Get-Process | ft -Property ID,name,@{n='VM(MB)';e={$_.vm /1MB}}


Get-History write a command taht dispplays a list or recentl run commands inlcuding the id

Get-History |ft -Property ID,CommandLine

help Get-History| gm

Get-History | Fl -Property ID,CommandLine,@{n='Time';e={$_.StartExecutionTime}} 
Get-History | select -Property Id,CommandLine,@{n='ElaspedTime1';e={ $_.EndExecutionTime - $_.StartExecutionTime }} | Sort-Object -Property ElaspedTime1 -Descending | Fl -AutoSize -Property ID,ElaspedTime,Commandline -Wrap

Get-History | select -Property ID,CommandLine,@{n='TimeBetween';e={$_.StartExecutiontime }}

Get-History | gm

Get-History | select -Property ID,CommandLine,@{n='time';e={$_.EndExecutionTime - $_.StartExecutionTime}}

Get-Service | gm

Get-Service | select -Property Site,Name,@{n='runningstatus';e={$_.status -eq 'Running'}},status | Sort-Object -Property runningstatus|  ft Name,Site,Status,runningstatus -AutoSize


