Get-PSProvider
Get-PSDrive

Get-Command -Noun psdrive
New-PSDrive -Name win -PSProvider FileSystem -Root C:\Windows
win:\appcompat

Get-Command -Noun item*
help Get-ChildItem
help New-PSDrive
dir -Path C:\Windows -Filter *.dll
dir -Path HKCU:\SOFTWARE -Filter win*

help registry

Update-Help

help registry
help provider

Get-ItemProperty -Path C:\Powershell\baseline.xml | select *
Set-ItemProperty -Path C:\Powershell\baseline.xml -Name isreadonly $true

cd HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer
Get-ItemProperty

Get-
