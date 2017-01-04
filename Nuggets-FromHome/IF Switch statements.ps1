$procs =Get-Process

If ($procs.Count -gt 100){
    write-host "Over 100 Processes"
}ElseIf ($procs.Count -lt 5) {
    Write-Host "under 5 processes"
}ElseIf ($procs[0].name -like 'a*') {
    Write-Host "the first proc starts with A"
}Else{
    Write-Host "Less than 100 Processes!"
}


$disk = Get-WmiObject -Class win32_logicaldisk | select -first 1

switch ($disk.drivetype) {

     2 { write-host "Floppy" }
     3 { Write-Host "Fixed" }
     4 { Write-Host "optical" }
     default { Write-Host "dunno" }
}


$name = Read-Host "Enter Server Name"

Switch -Wildcard ($name){
    "*DC*" {
    Write-Host "Is a domain controller"
           }
    "*FS*" {
    Write-Host "Is a file server"
           }
    "*NYC*" {
    Write-Host "is in New York"
            }
    "*LON*" {
    Write-Host "is in London"
            }
}

LON-FS-02
NYC-DC-01

HELP about_switch

$name = Read-Host "Enter Server Name"

Switch -regex ($name){
    "DC" {
    Write-Host "Is a domain controller"
           }
    "FS" {
    Write-Host "Is a file server"
           }
    "^NYC" {
    Write-Host "is in New York"
            }
    "^LON" {
    Write-Host "is in London"
            }
}

$name = Read-Host "Enter Server Name"
if ($name -match "dc") {write-host "Domain controller"}
if ($name -match "fs") {write-host "File Server"}
if ($name -match "^NYC") {write-host "New York"}
if ($name -match "^Lon") {write-host "London"}