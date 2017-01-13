$cred = Get-Credential
$auto = New-PSSession -Name Auto -ComputerName win10entpreview -Credential $cred
 
Copy-Item -Path C:\Packages\dave\badger.txt -Destination C:\packages\badger.txt -ErrorAction
Copy-Item -Path C:\packages\test.txt -Destination C:\Packages\dave\test.txt -FromSession $auto

$File = [System.IO.File]::ReadAllBytes( “C:\Packages\dave\badger.txt” )


Invoke-Command -session $session -ArgumentList $file -ScriptBlock {[System.IO.File]::WriteAllBytes(“C:\localfile2.txt”,$args)}
