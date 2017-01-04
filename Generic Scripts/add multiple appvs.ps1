Set-ExecutionPolicy Unrestricted -Force

import-module AppvClient
$path = 'C:\Packages'

$Path2 = dir $path -Recurse | where {$_.Extension -eq '.appv'}

foreach ( $item in $path2  ){

Add-AppvClientPackage -path $item.FullName | Publish-AppvClientPackage -Global

}