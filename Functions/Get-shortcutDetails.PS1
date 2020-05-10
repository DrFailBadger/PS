param (
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   Position=1,
                   HelpMessage='Computername',
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername,

        [Parameter(Position=2)]
        [ValidateSet('Test1','Packaging','Seqencer','Custom')]
        [String]$XMLSelected =  'Custom'
)

function Write-Log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path=$DWPLogPath,
        
        [Parameter(Mandatory=$false,
                   Position=1)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )
    Begin{}
    Process
    {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        $FormattedDate = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

        switch ($Level) {
            'Error' {$LevelText = 'ERROR:'}
            'Warn' {$LevelText  = 'WARNING:'}
            'Info' {$LevelText  = 'INFO:'}
            }

        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End{}
}

#Variables
Write-Log "Start Shortcut Details" 
[Array]$errorall = $null
[array]$AllShortcuts = $null
$sh = New-Object -ComObject WScript.Shell
$CommonPrograms = [Environment]::GetFolderPath('CommonPrograms')
$CommonAppDataPrograms = [Environment]::GetFolderPath('StartMenu') + "\Programs"
$ConfigPath = "C:\ShortcutDetails\config\"
#$ConfigPath = "$PSScriptRoot\Config\"

$AllShortcuts += Get-ChildItem $CommonPrograms -File -Recurse
$AllShortcuts += Get-ChildItem $CommonAppDataPrograms -File -Recurse


#Check Config Folder Exists
IF(!(Test-Path $ConfigPath)){
    try {
        New-Item -ItemType Folder -Path $ConfigPath -Force -ErrorAction Stop -ErrorVariable X
        Write-Log "Creating $configPath was Successful"
    }
    catch {
        $errorall += $x
        Write-Log "Creating $configPath was Unsuccessful" -Level Error
        Write-Log "PowerShell Error[$($_.exception.message)]"  -Level Error  
    } 
}

##XML Switch

switch ($XMLSelected) {
    Test1        { $XMLimport = $ConfigPath + "Shortcuts_Test1.xml"     }
    Packaging    { $XMLimport = $ConfigPath + "Shortcuts_Packaging.xml" }
    Sequencer    { $XMLimport = $ConfigPath + "Shortcuts_Sequencer.xml" }
    Custom       { $XMLimport = $ConfigPath + "Shortcuts_Custom.xml"    }
    #Default      { Shortcuts_Test1.xml}
}

#Check XML if XML is present, if not create base XML.

IF(!(Test-Path $XMLimport)){
    try {
        Get-ShortcutDetails |Export-Clixml $XMLimport
        
        Write-Log "Creating $XMLImport as base was Successful"
    }
    catch {
        $errorall += $x
        Write-Log "Creating $XMLImport as base was Unsuccessful" -Level Error
        Write-Log "PowerShell Error[$($_.exception.message)]"  -Level Error  
    }

        $NewShortcuts = Get-ShortcutDetails 
        Compare-c

}


#[String]$AppName = Read-Host -prompt 'Application Name'
#[String]$ShorcutFolder = Read-Host -prompt 'Shorcut SubFolder - Leave Blank for All Start Menu'

#$LogLocation = "C:\Git\"
#$loglocation= $($LogLocation.TrimEnd('\'))
#$ShortcutOut = "$LogLocation\$Appname`_ShortcutDetails.txt"

#$ShorcutFolder = Read-Host -prompt 'Shorcut SubFolder - Leave Blank for All Start Menu'





#$sm = "$CommonPrograms\$ShorcutFolder"


$AllShortcuts | Export-Clixml C:\ShortcutDetails\Config\Test1.xml








Import-Clixml $ImportXML
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