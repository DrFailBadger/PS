param(
    [string[]]$ComputerName
)

Get-DriveInfo -ComputerName $ComputerName |
Select-Object -Property ComputerName,DriveLetter,DriveKind,FreeSpace,Capacity,@{name='Free%';expression={$_.FreeSpace / $_.Capacity * 100 -as [int]}} |
ConvertTo-HTML -PreContent "<h1>Drive Info Report</h1>" |
Out-File driveinforeport.html
