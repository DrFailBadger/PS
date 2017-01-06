#Set-ExecutionPolicy Unrestricted -Force

import-module AppvClient
$path = 'C:\Packages'

dir $path -Recurse -Include "*.Appv" |

foreach {

Add-AppvClientPackage -path $_.FullName | Publish-AppvClientPackage -Global

}

#Get-AppvClientPackage | Remove-AppvClientPackage