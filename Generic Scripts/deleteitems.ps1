$tdc='C:\UAM\'
$a = Get-ChildItem $tdc -recurse | Where-Object {$_.PSIsContainer -eq $True}
$a | Where-Object {$_.GetFiles().Count -eq 0 -and $_.Name -eq "installation"} | Remove-Item