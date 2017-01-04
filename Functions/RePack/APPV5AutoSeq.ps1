Function AutoSeqAV5{
     
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                    HelpMessage = "Installer for Sequencer to run. Example Setup.exe or Install.cmd")]  
        [string]$Installer,

        [Parameter(Mandatory=$false,
                    HelpMessage = 'BaseFolder, this defaults to "C:\packages"')]
        [ValidateScript({Test-Path $_ })] 
        [string]$BaseLocation = 'C:\packages',


        [Parameter(Mandatory=$false,
                    HelpMessage = 'User Template for conversion? True / False, true will use the Atos.AppVt')]
        [switch]$TemplateFilePath,

        [Parameter(Mandatory=$true,
                    HelpMessage = 'AppV Package Name (Once completed)')]
        [string]$AppV5Name
        
        )
        

        [string]$InstallApp = "'$BaseLocation\$installer'"
     
        [string]$OutputLocExpand = "`"$BaseLocation\ExpandOutput`""

        If ($TemplateFilePath-eq $True){
            $AppvCommandLine += " -TemplateFilePath '$BaseLocation\Atos.appvt'"
        }

        $AppvCommandLine = "New-AppvSequencerPackage -FullLoad -Installer $InstallApp -Name $Appv5Name -Path $OutputLocExpand -Verbose"



}



#Set-ExecutionPolicy Unrestricted -Force
$PackageFolder = "C:\packages"
$ServerAppData = "C:\packages\ServerINIS"
$ENVTXT = Get-Content -Path "$PackageFolder\ENV.txt"
$SeqOutPut = "$PackageFolder\SeqOutput"



Foreach ($TxtItem in $EnvTxt) {
    
    set-Content -Path "$PackageFolder\Install.cmd" -Value "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file `"C:\packages\Thaler Installer.ps1`" -ThalerENV $TxtItem -PackageFolder `"$PackageFolder`" -ServerAppData `"$ServerAppData`"" | Out-null
    New-AppvSequencerPackage -FullLoad -Installer "$PackageFolder\install.cmd" -TemplateFilePath "$PackageFolder\Atos.appvt" -Name "Thaler-3103-AV5-$TxtItem-R01-R01" -Path "$SeqOutPut" -Verbose | Out-Null



    }Help about_