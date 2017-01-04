$BaseLocation = "C:\Packages"

$ZipPackagePath = dir -Path $BaseLocation -Recurse -Include '*.zip'
$PP =$ZipPackagePath.BaseName

Add-Type -assembly “system.io.compression.filesystem”

[io.compression.zipfile]::ExtractToDirectory($ZipPackagePath, $BaseLocation)


extract-zip $folder $older
New-InstallCMD -Mode Setup
Start-RepackInstall -pp $pp
