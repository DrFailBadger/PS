[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage='Select Which XML base to use')]
    [ValidateSet('Test1','Packaging','Sequencer','Custom')]
    [String]$XMLSelected =  'Custom',
    [String]$Configpath = "$PSScriptRoot\config",
    [String]$Output = "$PSScriptRoot\output"
)

$ShorcutDetailsLog = "$PSScriptRoot\log\Get-ShortcutsDetails.log"
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
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$FilterName
    )
    $CommonPrograms = [Environment]::GetFolderPath('CommonPrograms')
    $CommonAppDataPrograms = [Environment]::GetFolderPath('StartMenu') + "\Programs"

    [Array]$AllShortcuts += Get-ChildItem -filter $FilterName $CommonPrograms -File -Recurse
    [Array]$AllShortcuts += Get-ChildItem -filter $FilterName $CommonAppDataPrograms -File -Recurse
    $AllShortcuts
}


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
        [ValidateSet('Test1','Packaging','Sequencer','Custom')]
        [String]$XMLSelected =  'Custom',

        [Parameter(Mandatory=$false)]
        [String]$ConfigPath = "$PSScriptRoot\Config\",
        [String]$Output = "$PSScriptRoot\output\"
    )
    
    begin {
        [Array]$1 = $null
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
        #Check Output Folder Exists
        IF(!(Test-Path $Output)){
            try {
                New-Item -ItemType Folder -Path $Output -Force -ErrorAction Stop -ErrorVariable X
                Write-Log "Creating $Output was Successful"
            }
            catch {
                $errorall += $x
                Write-Log "Creating $Output was Unsuccessful" -Level Error
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
                [Array]$AllShortcuts = Get-AllShortcuts
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
            [Array]$AllShortcuts = Get-AllShortcuts
            $XMLimport = "C:\ShortcutDetails\Config\Shortcuts_Packaging.xml"
            $BaseLine = Import-Clixml $XMLimport
            $compared = Compare-Object -ReferenceObject $BaseLine -DifferenceObject $AllShortcuts -Property Name
            
            foreach ($NewShortcut in $compared) {
                #[Array]$1 = $null
                if ($NewShortcut.SideIndicator -eq "=>") {
                    $SCName = $NewShortcut.Name
                    $NewShortcuts = Get-AllShortcuts -FilterName $SCName
                    $1 += Get-ShortcutDetails -shortcut $NewShortcuts   
                    $1 += ""
                }
                
            }
            $1 | Out-File -FilePath $Output\$XMLSelected`_Shortcut_details.txt -Force
        }
    }end{

    }
}


Get-BaseXML -ConfigPath $Configpath -Output $Output -XMLSelected $XMLSelected

 


 



