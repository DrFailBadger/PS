$Path = "C:\UAM\_MassConversion\New Source"
$dirPath = dir $Path | Select-Object -Property FullName
$dirPath
$ZipInput = $dirPath
Invoke-ZipArchive -ZipInput $dirPath.fullname -ZipOutput "C:\UAM\_MassConversion\New Zip"