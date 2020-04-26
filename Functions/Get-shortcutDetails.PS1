param (
   
    [Parameter(Mandatory=$True,
        HelpMessage = "Log Folder Location.")]
    [ValidateScript({(Test-Path $_)})] 
    [String]$LogLocation = "\\FS01\WIP\David\Logs\ShortcutDetails\"
)

[String]$AppName = Read-Host -prompt 'Application Name'
[String]$ShorcutFolder = Read-Host -prompt 'Shorcut SubFolder - Leave Blank for All Start Menu'

#$LogLocation = "C:\Git\"
$loglocation= $($LogLocation.TrimEnd('\'))
$ShortcutOut = "$LogLocation\$Appname`_ShortcutDetails.txt"

#$ShorcutFolder = Read-Host -prompt 'Shorcut SubFolder - Leave Blank for All Start Menu'


$sh = New-Object -ComObject WScript.Shell
$CommonPrograms = [Environment]::GetFolderPath('CommonPrograms')
$sm = "$CommonPrograms\$ShorcutFolder"

$link = (Get-ChildItem $sm -File -Recurse)

foreach ($lnk in $Link) {
    $lnk1 = $sh.CreateShortcut($lnk.FullName) 
    if ($lnk1.IconLocation -eq ",0") {
        $IconLocation = $lnk1.TargetPath + $lnk1.IconLocation
    }Else{
        $IconLocation = $lnk1.IconLocation
    }
    $Props = [Ordered]@{
        Name                =   $lnk.BaseName
        'StartMenu Location'=   $lnk.DirectoryName
        'Full Path'         =   $lnk1.FullName
        'Target Path'       =   $lnk1.TargetPath
        Arguments           =   $lnk1.Arguments
        'Working Directory' =   $lnk1.WorkingDirectory
        'Icon Location'     =   $IconLocation
        Description         =   $lnk1.Description
    }
    $props | Out-File $ShortcutOut -Append -Width 500
    
}
Write-Host "Log Location $ShortcutOut"
Invoke-Item $ShortcutOut
Pause