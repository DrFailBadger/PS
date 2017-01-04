Function Start-RepackInstall{
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$false,
                    HelpMessage = "Installer for Repacker to run. Example Setup.exe or Install.cmd")]  
        [string]$Installer = "Install.cmd",
        ###vaildate has no path and is in base folder
                       
        [Parameter(Mandatory=$false,
                    HelpMessage = "Accepts 'Snap' for Repackager with Snapshots or 'Monitor' for Repackager with installation monitoring.")]
        [ValidateSet('Snap','Monitor')]
        [String]$packmethod ='Snap',

        [Parameter(Mandatory=$false,
                    HelpMessage = "Changes silent mode -sb -sn -s.")]
        [ValidateSet('Silent None','Silent', 'Silent Basic','Silent Full')]
        [String]$SilentSwitch ='Silent Basic',

        [Parameter(Mandatory=$false,
                    HelpMessage = 'CompanyName')]
        [string]$CP = 'CompanyName',

        [Parameter(Mandatory=$false,
                    HelpMessage = 'Product Version')]
        $ProductVersion = '1.0',

        [Parameter(Mandatory=$true,
                    HelpMessage = 'ProductName')]
        [string]$PP,

        [Parameter(Mandatory=$false,
                    HelpMessage = 'BaseFolder example "C:\package"')]
        [ValidateScript({Test-Path $_ })] 
        [string]$BaseLocation = 'C:\packages',

        [Parameter(Mandatory=$false,
                   HelpMessage = 'Choose build options, Build, Buildonly, :$null or BuildWtISM (if BuildWtISM is selected, make sure ISM is added to -ISMTemplate')]
        [ValidateSet('Build','BuildOnly','BuildWtISM',"NoBuild")]
        [string]$build ='Build',

        [Parameter(Mandatory=$false,
                   HelpMessage = "ISM (template) Location, Example 'c:\packages\UAM5.0StdWin7.ism'")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".ism") -and ($build -eq 'BuildWtISM')})]
        [string]$ISMTemplate
    )


    #[string]$Installer = "Install.cmd"
    [string]$RepackLocation = 'C:\Program Files\Repackager'

    [string]$RepackExe = "$RepackLocation\Repack.exe"

    [string]$InstallApp = "`"$BaseLocation\$installer`""
     
    [string]$OutputLocExpand = "`"$BaseLocation\Output`""

    Switch($packmethod){
        'Snap'{$packmethod1 ='-mp -mode single'
         }
        'Monitor'{$packmethod1 ='-mm'
         }
    }

    Switch($build) {
        'Build' {$build1 = "-aacb" }
        'BuildOnly' { $build1 = "-aacb -aacbuildonly" }
        'BuildWtISM' { $build1 = "-aacb $ISMTemplate -aacbbuildonly" }
        'NoBuild' { $build1 = $null }
     }

    Switch($SilentSwitch) {
        'Silent None' { $SilentSwitch1 = "$null" }
        'Silent' { $SilentSwitch1 = "-s" }
        'Silent Basic' { $SilentSwitch1 = "-sb" }
        'Silent Full' { $SilentSwitch1 = "-sn" }
     }


    
    $arguments = "-app $InstallApp $build1 $PackMethod1 -pp $PP -pc $CP -pv $ProductVersion -o $OutputLocExpand $SilentSwitch1"
    #Write-host $arguments

    Start-Process -FilePath $RepackExe -ArgumentList $Arguments

}

Function New-InstallCMD{

    Param (

        [Parameter(Mandatory=$false,
                    HelpMessage = 'BaseFolder')]
        [ValidateScript({Test-Path $_ })] 
        [string]$BaseLocation = 'C:\Packages',
       

        [Parameter(Mandatory=$false)]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".com")})]  
        [string]$SeqPath = 'C:\Program Files\Microsoft Application Virtualization Sequencer\SFTSequencer.com',

        [Parameter(Mandatory=$false)]
        [string]$BrickName,

        [Parameter(Mandatory=$false)]
        [string]$SetupArgument = '/s',

        [Parameter(Mandatory=$false)]
        [ValidateSet('AppV4','AppV5','Setup')]
        [String]$Mode

    )

  
    #$BrickName = dir -Path $BaseLocation -Directory
    #$SeqPath = 'C:\Program Files\Microsoft Application Virtualization Sequencer\SFTSequencer.com'


    Switch($mode) {
    'AppV4' { 
        $appV4PackagePath = dir -Path $BaseLocation -Recurse -Include '*.sprj' |  Where {$_.BaseName}
        set-Content -Path "$BaseLocation\Install.cmd" -Value "`"$SeqPath`" /expand:`"$appV4PackagePath`""
        }
    'AppV5' {
        $AppVExpanderPS1 = "$BaseLocation\AppVExpander.ps1"
        $appV5PackagePath = dir -Path $BaseLocation -Recurse -Include '*.Appv' |  Where {$_.BaseName}
        Set-Content -Path $AppVExpanderPS1 -value 'Param(  
     
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".appv")})]  
        [Parameter(Mandatory=$True)]  
        [string]$AppVPackagePath  

        )


        Expand-AppvSequencerPackage -AppvPackagePath $AppVPackagePath' -Force


        set-Content -Path "$BaseLocation\Install.cmd" -Value "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file '$AppVExpanderPS1' -AppVPackagePath `"$appV5PackagePath`""
        }
    'Setup' {
        $SetupArgument1 = $SetupArgument
        $SetupPackagePath = dir -Path $BaseLocation -Recurse -Include '*.exe' |  Where {$_.BaseName}
        set-Content -Path "$BaseLocation\Install.cmd" -Value "`"$SetupPackagePath`" $SetupArgument1"

        }
    }
}



#PS C:\Packages> Start-RepackInstall -Installer install.cmd -packmethod snap -build BuildWtISM -BaseLocation C:\Packages -ProductVersion 1.0 -pp productname -cp companyname -ISMTemplate C:\packages\UAM5.0StdWin7.ism
#-app "C:\Packages\install.cmd" -aacb C:\packages\UAM5.0StdWin7.ism -aacbbuildonly -mp -mode single -pp productname -pc companyname -pv 1.0 -o "C:\Packages\ExpandOutput" -sb