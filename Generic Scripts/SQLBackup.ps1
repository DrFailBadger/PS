Import-Module sqlps
$dt = Get-Date -Format yyyyMMddHHmmss
$dbname = 'New2'
Backup-SqlDatabase -ServerInstance "$env:computername\SQLEXPRESS"  $dbname -BackupFile "C:\DBbackups\$($dbname)_db_$($dt).bak"
#Backup-SqlDatabase -ServerInstance "MC0W74WC\SQLEXPRESS" -Database 'Dave'

$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("dave_Data", "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\dave.mdf")
$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("dave_Log", "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dave.ldf")
Restore-SqlDatabase -ServerInstance "$env:computername\SQLEXPRESS" -Database "dave" -BackupFile "C:\DBBackups\dave_db_.bak" -RelocateFile @($RelocateData,$RelocateLog)

Restore-SqlDatabase -ServerInstance "$env:computername\SQLEXPRESS" -Database "new1" -BackupFile "C:\DBBackups\dave_db_20161103143338.bak" -ReplaceDatabase

Import-Module sqlps

$databaseServerInstance = "$env:computername\SQLEXPRESS"
$srv = new-object Microsoft.SqlServer.Management.Smo.Server($databaseServerInstance)
$database = "New2"
$backupLocation ="C:\DBBackups\New2_db_20161104072616.bak"

# If the database exists then drop it otherwise Restore-SqlDatabase may fail if connections are open to it
if ($srv.Databases[$database] -ne $null)
{
    $srv.KillAllProcesses($database)
    $srv.KillDatabase($database)
}


Restore-SqlDatabase -ServerInstance $databaseServerInstance -Database $database -BackupFile $backupLocation -ReplaceDatabase