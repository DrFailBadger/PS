

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
        [string]$Path=$ShorcutDetailsLog,
        
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
#$ShorcutDetailsLog = "$PSScriptRoot\log\Get-ShortcutsDetails.log"


function Get-AllShortcuts{
    $CommonPrograms = [Environment]::GetFolderPath('CommonPrograms')
    $CommonAppDataPrograms = [Environment]::GetFolderPath('StartMenu') + "\Programs"

    [Array]$AllShortcuts += Get-ChildItem $CommonPrograms -File -Recurse
    [Array]$AllShortcuts += Get-ChildItem $CommonAppDataPrograms -File -Recurse
    
    switch ($XMLSelected) {
        Test1        { $XMLimport = $ConfigPath + "Shortcuts_Test1.xml"     }
        Packaging    { $XMLimport = $ConfigPath + "Shortcuts_Packaging.xml" }
        Sequencer    { $XMLimport = $ConfigPath + "Shortcuts_Sequencer.xml" }
        Custom       { $XMLimport = $ConfigPath + "Shortcuts_Custom.xml"    }
        #Default      { Shortcuts_Test1.xml}
    }

}


Get-ChildItem -Filter ""
function Get-ShortcutDetails ($shortcut) {
    $sh = New-Object -ComObject WScript.Shell
    foreach ($lnk in $Shortcut) {
        $lnk1 = $sh.CreateShortcut($lnk.FullName) 
        if ($lnk1.IconLocation -eq ",0") {
            $IconLocation = $lnk1.TargetPath + $lnk1.IconLocation
        }Else{
            $IconLocation = $lnk1.IconLocation
        }
        $Props = [Ordered]@{
            Name                =   $lnk.BaseName
            'StartMenu Location'=   $Lnk.DirectoryName
            'Full Path'         =   $lnk1.FullName
            'Target Path'       =   $lnk1.TargetPath
            Arguments           =   $lnk1.Arguments
            'Working Directory' =   $lnk1.WorkingDirectory
            'Icon Location'     =   $IconLocation
            Description         =   $lnk1.Description

        }
        $Props
    }
           
}

function Get-BaseXML {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        HelpMessage='Select Which XML base to use')]
        [ValidateSet('Test1','Packaging','Seqencer','Custom')]
        [String]$XMLSelected =  'Custom',

        [Parameter(Mandatory=$true)]
        [String]$ConfigPath = "$PSScriptRoot\Config"
    )
    
    begin {
        
        
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
        #XML Switch
        switch ($XMLSelected) {
            Test1        { $XMLimport = $ConfigPath + "Shortcuts_Test1.xml"     }
            Packaging    { $XMLimport = $ConfigPath + "Shortcuts_Packaging.xml" }
            Sequencer    { $XMLimport = $ConfigPath + "Shortcuts_Sequencer.xml" }
            Custom       { $XMLimport = $ConfigPath + "Shortcuts_Custom.xml"    }
            #Default      { Shortcuts_Test1.xml}
        }
    }
    
    process {
        IF(!(Test-Path $XMLimport)){
            try {
                $AllShortcuts| Export-Clixml $XMLimport
                Write-Log "Creating $XMLImport as base was Successful, Rerun tool once application is installed"
                #Popup Saying Base XML created
                Write-Host "Creating $XMLImport as base was Successful, Rerun tool once application is installed"
            }
            catch {
                $errorall += $x
                Write-Log "Creating $XMLImport as base was Unsuccessful" -Level Error
                Write-Log "PowerShell Error[$($_.exception.message)]"  -Level Error  
            }
                    
        }Else{
            $BaseLine = Import-Clixml $XMLimport
            $compared = Compare-Object -ReferenceObject $BaseLine -DifferenceObject $AllShortcuts -Property Name

        }
    }
    
    end {
        
    }
}

$compared = Import-Clixml  
$AllShortcuts =Get-AllShortcuts
$AllShortcuts | export-clixml C:\ShortcutDetails\Config\Shortcuts_Packaging.xml
$1 = import-clixml C:\ShortcutDetails\Config\Shortcuts_Packaging.xml
$Compared = Compare-Object -ReferenceObject $1 $AllShortcuts -Property Name
foreach ($NewShortcut in $compared[2]) {
    if ($NewShortcut.SideIndicator -eq "=>") {
        $SCName = $NewShortcut.Name

    }
   

$CommonPrograms = [Environment]::GetFolderPath('CommonPrograms')
$CommonAppDataPrograms = [Environment]::GetFolderPath('StartMenu') + "\Programs"
[Array]$AllShortcuts += Get-ChildItem $CommonPrograms -File -Recurse
[Array]$AllShortcuts += Get-ChildItem $CommonAppDataPrograms -File -Recurse
$AllShortcuts | Where-Object {$_.name -eq $($comp.name)}
Get-ChildItem -Filter "$compared.name" -Path $CommonPrograms
$Compared.name

foreach ($Comp in $compared) {
    $NewShortcut = @()
    $NewShortcut += Get-ChildItem -Filter $($Comp.name) -Path $CommonPrograms -File -Recurse
    $NewShortcut += Get-ChildItem -Filter $($Comp.name) -Path $CommonAppDataPrograms -File -Recurse

}
    
}


$ShorcutDetailsLog = "C:\ShortcutDetails\log\Get-ShortcutsDetails.log"
$AllShortcuts[0] = Get-AllShortcuts
$ConfigPath = "C:\ShortcutDetails\config\"

$ShortcutOut = Get-AllShortcuts

$shortcut =$ShortcutOut


$compared
Get-ShortcutDetails -shortcut $ShortcutOut
$outputloc = "C:\ShortcutDetails\output"
$outputloc = "$PSScriptRoot\output"
$the = $ShortcutOut | get-shortcutdetails 
if (!(Test-Path $outputloc)) {
    New-Item -Path $outputloc -ItemType Directory -Force
}
$the | out-file "C:\ShortcutDetails\Output\Shortcut-details.txt" -Force
Pause