$users = Get-ChildItem C:\Users
$ProductVersion = '.platform=1.6'

foreach ($user in $users){
    $Path1 = "C:\users\" + $user + "\appdata\LocalLow\Sun\Java\deployment\deployment.properties"
    If (Test-Path $Path1){
        $DPContent = Get-Content $path1
        $Linecont = $DPContent | ? {$_ -match $ProductVersion}
        #If ($linecont -ne $null){
        $A += $Linecont.Split('.',5)
        $DPContent | ? {$_ -notmatch ".$($A[2]).$($A[3])."} | Set-Content $path1
        #}
    }
}
