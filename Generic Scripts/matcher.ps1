$wshell = New-Object -ComObject Wscript.Shell
$alreadyfound =@()
$Notfound = @()
foreach($app in $AllApps){

$found=@()
$found += $allOldApps1|Where-Object {($_.Application_x0020_Name.Trim().Substring(0,3) -match $app.Application_x0020_Name.Trim().Substring(0,3)) -and ($_.Application_x0020_Version.Trim().Substring(0,3) -match $app.Application_x0020_Version.Trim().Substring(0,3))  }
$match = $false
Foreach($item in $Found){
$yesno = $wshell.Popup("RequestApplication = $($app.Application_x0020_Name)   $($app.Application_x0020_Version)
OldTrackerApp = $($item.Application_x0020_Name)   $($item.Application_x0020_Version)  
",0,"Apps",0x4)

if($yesno -eq 6){
$alreadyfound += $app |Select-Object *,@{Name='OLDID';Expression={"$($item.Title)"} },@{Name='Source';Expression={"$($item.Source)"} }
$match = $true
}

}
IF($match -ne $true){
$Notfound += $app
}


}