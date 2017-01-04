 "abcdefg124435" -match "\d+"
# -notmatch - true or false

$Matches
##Regular expressions
 "abcdefg124435" -match ("\d+")
 "this that those" -replace "that","x"
  "this that those" -replace "\s[a-z]+\s","-"
  
  "don jones" -replace "([a-z]+)\s([a-z]+)",'$2, $1' #switches positions jones, don (output)
  cd C:\Windows\Logs\
  dir
  cd c:\windows\
 Get-Item *.log
 Get-ChildItem -Include 
 cd "C:\Powershell\LogFiles"

 Get-ChildItem -Recurse -Include *.log | Select-String -Pattern "\s(\d{1,3})\."


  Get-ChildItem -Recurse -Include *.log | Select-String -Pattern "10.211.55.30" -SimpleMatch -List

  help Select-String
  help Select-Object
  help Add-Type -Examples
