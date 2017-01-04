$Path = "C:\"
$basefolder = dir -Path $Path

foreach($item in $basefolder){

$osds = Dir "$($item.FullName)"|Where-Object -Property Extension -eq ".osd"

$addinline = $null
foreach($line in $osds){
IF($addinline -eq $null){$addinline = "    <SHORTCUT Path=`"$($line.Name)`" />"}
else{
$addinline = "$addinline`n    <SHORTCUT Path=`"$($line.Name)`" />"
}
}

$i = 0
$addinline.Split(“`n”) | ForEach-Object {$i++}
$secondsize = $i


$addinline = "  <SHORTCUTS>`n$addinline`n  </SHORTCUTS>"




$sprj = Dir "$($item.FullName)"|Where-Object -Property Extension -eq ".sprj"
 

$sprjcontent = Get-Content $sprj[0].FullName

$linefound = $false
$newsprj = $null
$i = 0
foreach($line in $sprjcontent){

if($line -match "<SHORTCUTS>"){
$linefound = $True
$newsprj = "$newsprj`n$addinline"
}elseif($linefound -eq $True){
$i++
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
$sprj = Dir "$($item.FullName)"|Where-Object -Property Extension -eq ".sprj"
$i--
$firstsize = $i 

if($secondsize -gt $firstsize){

"Modified = True  before = $firstsize after = $secondsize $($item.FullName)" >> "$Path\one.log"
}

}