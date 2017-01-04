$Path = "C:\"
$basefolder = dir -Path $Path

foreach($item in $basefolder){


$osds = Dir "$($item.FullName)"|Where-Object -Property Extension -eq ".osd"

$addinline = "  <SHORTCUTS>"
foreach($line in $osds){
$addinline = "$addinline`n    <SHORTCUT Path=`"$($line.Name)`" />"
}

$addinline = "$addinline`n  </SHORTCUTS>"

$sprj = Dir "$($item.FullName)"|Where-Object -Property Extension -eq ".sprj"

$sprjcontent = Get-Content $sprj[0].FullName

$linefound = $false
$newsprj = $null
foreach($line in $sprjcontent){

if($line -match "<SHORTCUTS>"){
$linefound = $True
$newsprj = "$newsprj`n$addinline"
}
if($line -match "</SHORTCUTS>"){
$linefound = $False
}
if($linefound -eq $false -and ($line -notmatch "</SHORTCUTS>")){
IF($newsprj -eq $null){
$newsprj = "$line"
}else{
$newsprj = "$newsprj`n$line"
}
}
}


$newsprj > "$($sprj[0].DirectoryName)\$($sprj[0].basename).sprj"

}