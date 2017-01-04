
$connectionString = ""
$conn = New-Object -TypeName System.Data.SqlClient.SqlConnection
$conn.ConnectionString = $connectionString
$conn.open()


$drives = Get-DriveInfo -ComputerName DC,localhost -DriveTypeFilter 3
foreach ($drive in $drives) {
    $sql = "INSERT INTO drivedata (today,computername,drive,freespace) VALUES ('$(get-date)','$($drive.computername)','$($drive.driveletter)','$($drive.freespace)')"
    $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand
    $cmd.Connection = $conn
    $cmd.CommandText = $sql
    $cmd.ExecuteNonQuery()
}



$conn.Close()