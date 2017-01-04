
Get-Process|foreach{IF($_.CPU -gt 1.5){$test += "CPU Usage for $($_.Name) is greater than 1.5 usage is $($_.CPU)"}}

New-AppvSequencerPackage -name "dave" -PrimaryVirtualApplicationDirectory "C:\Program Files\Common Files" -OutputPath "c:\packages\" -Installer "C:\Packages\Install.cmd"
