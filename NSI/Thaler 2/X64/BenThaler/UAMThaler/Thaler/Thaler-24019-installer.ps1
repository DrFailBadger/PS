[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$ThalerENV,
    [Parameter(Mandatory=$False)]
    [string]$PackageFolder= 'C:\Packages\Thaler',
    [Parameter(Mandatory=$True)]
    [string]$ServerAppData = '\\netappnsi01a\appvapps\appdata'
)

$packageFiles = "$PackageFolder\Files"

#Creates Installation Directory
$ThalerInstallDirectory = "${ENV:ProgramFiles(x86)}\Thaler\Thaler 2.40.19"
MD $ThalerInstallDirectory -Force -ErrorAction SilentlyContinue
$TargetExe = "$ThalerInstallDirectory\Thaler.exe"

#Creates HKLM Route keys
$registryPath = "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Callataÿ & Wouters\Thaler"
MD $registryPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $registryPath -Name "envreg" -Value "$ThalerENV" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $registryPath -Name "ServerAppDatareg" -Value "$ServerAppData" -PropertyType String -Force | Out-Null 
New-ItemProperty -Path $registryPath -Name "DirInstall" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null 
New-ItemProperty -Path $registryPath -Name "MergeVisible" -Value "N" -PropertyType String -Force | Out-Null 

#Creates registry in HLKM sub keys
MD "$registryPath\$ThalerENV" -Force -ErrorAction SilentlyContinue
MD "$registryPath\2.1" -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "$registryPath\$ThalerENV" -Name "PathExcel" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null 
New-ItemProperty -Path "$registryPath\$ThalerENV" -Name "PathWord" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null 
New-ItemProperty -Path "$registryPath\$ThalerENV" -Name "TrgPathExcel" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$registryPath\$ThalerENV" -Name "TrgPathWord" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null

#Creates HKLM AppPath
$AppPathREg = "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\Thaler.exe"
MD $AppPathREg -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $AppPathREg -Name "(Default)" -Value "$TargetExe" -PropertyType String -Force | Out-Null 
New-ItemProperty -Path $AppPathREg -Name "Path" -Value "$ThalerInstallDirectory" -PropertyType String -Force | Out-Null 

#Creates HKCM Route keys
$registryPathHKCU = "Registry::HKEY_CURRENT_USER\Software\Callataÿ & Wouters\Thaler"
MD $registryPathHKCU -Force -ErrorAction SilentlyContinue
$Newregpath = "$registryPathHKCU\$ThalerENV"
MD $Newregpath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "$Newregpath" -Name "BlackAndWhite" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFFloating" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFHeight" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFLeft" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFTop" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFVisible" -Value "Y" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "CFWidth" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "DBold" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "DColor" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "DefaultSoc" -Value "1" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "DItalic" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "DUnderline" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFFloating" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFHeight" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFLeft" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFTop" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFVisible" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "EFWidth" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "ExcelInteraction" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "FontName" -Value "Verdana" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "FontSize" -Value "8" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFFloating" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFHeight" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFLeft" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFTop" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFVisible" -Value "Y" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HFWidth" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "HintPause" -Value "50000" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "Language" -Value "" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "LogScreen" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "NumPad" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "OBold" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "OColor" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "OItalic" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "OUnderline" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "PBold" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "PColor" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "PItalic" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "PrintFullSummary" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "PUnderline" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFFloating" -Value "N" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFHeight" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFLeft" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFTop" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFVisible" -Value "Y" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TFWidth" -Value "0" -PropertyType "dword" -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "TileMode" -Value " " -PropertyType String -Force | Out-Null
New-ItemProperty -Path "$Newregpath" -Name "WindowsCount" -Value "1" -PropertyType "dword" -Force | Out-Null
MD "$Newregpath\MenuTree" -Force -ErrorAction SilentlyContinue

#Sets Source Files Location / Copies Files to InstallDir
$SourceFiles = "$packageFiles\*.*"
Copy $SourceFiles $ThalerInstallDirectory -Force

#Creates Shorcut to Thalers with ENV in name
$ShortCutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\"
New-Item -Path "$ShortCutPath\Enterprise Applications" -ItemType directory
$TargetPSExe = "$ThalerInstallDirectory\ThalerII.exe"
$ShortcutFile = "$ShortCutPath\Enterprise Applications\Thaler v2 ($ThalerENV).lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetPSExe
$Shortcut.IconLocation = "$TargetExe, .0"
$Shortcut.save()