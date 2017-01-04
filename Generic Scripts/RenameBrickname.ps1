
$Path = Dir "C:\UAM\_MassConversion\Converted\"

Foreach($item in $path){
IF($item.Name -match "Encrypted-") {

#$Splitname1 =("$($item.Name.Substring(0,$Item.name.Length-20))`R01-R01").Replace("-AV-","-AV5-").Substring(10) 


$Splitname1 = ("$($item.Name.Substring(0,$Item.name.Length-20).Substring(10).Replace("-AV-","-AV5-"))`R01-R01")


Rename-Item "($item.FullName)" $Splitname1 
}
}