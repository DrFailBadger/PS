
Param (
    [String]$computername = (Read-Host "Computer Name to Query"),
    [Int]$DriveType = 3
)

Get-WmiObject -Class win32_logicaldisk -Filter "DriveType=$DriveType" -ComputerName $computername | 
Select-Object @{n='ComputerName';e={$_.__Server}},
              @{n='Drive';e={$_.deviceId}},
              @{n='Size(GB)';e={$_.Size /1GB -as [int]}},
              @{n='FreeSpace(GB)';e={$_.freespace /1GB -as [int]}}

