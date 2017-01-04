
$Path = Dir "C:\UAM\_MassConversion\Converted\test"
#$DirName =@()

Foreach($item in $path){
IF($item.Name -match "Encrypted-") {
#$DirName = $true
$FullPathName = $item.Name

$pieces=$FullPathName.Split("-")
$numbersofpieces=$pieces.count
$FILENAME=$PIECES[$NumberOfPieces-1]
$FILENAME2=$PIECES[$NumberOfPieces-$numbersofpieces]
$DIRECTORYPATH=$FullPathName.Trim("-$FILENAME"+"$FILENAME2-")
$newbrickname = $DIRECTORYPATH -replace "AV", "AV5"
$Splitnewname = $newbrickname.Substring(0,$newbrickname.Length-7)  
$FinalName = "$Splitnewname`R01-B01"

$
Rename-Item $item.FullName $newbrickname2
}

}

