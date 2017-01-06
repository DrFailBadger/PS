#Discover!
#Learn!
#Experiment!
#Revise!
#Complete!

Help *role*

help *feature*

Get-Command -module servermanager
help get-windowsfeature
help get-windowsfeature -full
get-windowsfeature -computername 



#####Process getting to task

Get-Command -module servermanager
help get-windowsfeature
help get-windowsfeature -full
get-windowsfeature -computername 2012r2-dc01 | gm

get-windowsfeature -computername 2012r2-dc01 | Where-Object installed
help Uninstall-WindowsFeature
get-windowsfeature -computername 2012r2-dc01 | Where-Object {$_.installed} | Select -

help get-windowsfeature -full #name parameter
get-windowsfeature -computername 2012r2-dc01 | Gm # produce feature onjecT?


get-windowsfeature -computername 2012r2-dc01 | Where-Object {$_.installed} |Export-Clixml baseline.xml
Import-Clixml .\baseline.xml|gm #still feature object

Get-WindowsFeature -computername 2012r2-dc01
Install-WindowsFeature -name telnet-client -ComputerName 2012r2-dc01


help compare-o
Compare-Object -ReferenceObject (Import-Clixml .\baseline.xml) -DifferenceObject (Get-WindowsFeature -ComputerName 2012r2-dc01 |Where-Object { $_.installed } )-Property name #name =telnet client
help compare-o
Compare-Object -ReferenceObject (Import-Clixml .\baseline.xml) -DifferenceObject (Get-WindowsFeature -ComputerName 2012r2-dc01 |Where-Object { $_.installed } )-Property name | select -ExpandProperty name

help Uninstall-WindowsFeature


Uninstall-WindowsFeature -ComputerName 2012r2-dc01 -Name (Compare-Object -ReferenceObject (Import-Clixml .\baseline.xml) -DifferenceObject (Get-WindowsFeature -ComputerName 2012r2-dc01 |Where-Object { $_.installed } )-Property name | Select-Object -ExpandProperty name) #name =telnet client
Get-WindowsFeature -ComputerName 2012r2-dc01 | where { $_.installed }






#####SCRIPT Final

Uninstall-WindowsFeature -ComputerName 2012r2-dc01 -Name (

    Compare-Object -ReferenceObject (Import-Clixml .\baseline.xml)`
                   -DifferenceObject (Get-WindowsFeature -ComputerName 2012r2-dc01 |Where-Object { $_.installed } )-Property name | Select-Object -ExpandProperty name
)
 #name =telnet client





