Pipeline
Plan A Value
Plan B PropertyName

#Get-Service [[-Name] <String[]>] #[[-Name] <String[]>]#square brackets around all = optional
#Get-Service -DisplayName <String[]> #no [] required parameter.
#Get-Service [[-Name] <String[]>] #[[-Name]# Brackets around Name = positional,dont need to use -name
#Get-Service [[-Name] <String[]>] #<String[]># <> accepts strings
#Get-Service [[-Name] <String[]>] #[]# multiple strings [Array]
##Positional paramters are relative, first positinal parameter we had used
-examples # switch parameters on or off



whatevers | GM
TypeName: 
Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_OperatingSystem   ###### MSDN for methods etc

whatevers | FL*
whatevers | Select -property *
whatevers | select -expandproperty Propertyname # to expand properties for

<-----------Filter Left | Format Right----------->

Truth Tables

And    True  False

True     x

False


OR     True  False

True    x      x

False   x


XOR    True  False

True           x

False    x


help New-PSDrive ##useful

##HASHTABLE
$HT = @{'Key1'='Value1'; 'Key2'='Value2'}
$ht.Key1
Value1

#Here String
$hs = @'
any text etc
read as one string


'@

#How to select objects.
get-adcomputer -filter * | Select-object @n{n='computername';e={$.name}}