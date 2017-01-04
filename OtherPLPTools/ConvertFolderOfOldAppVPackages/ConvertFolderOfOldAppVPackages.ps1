#################################################################################################################
### PURPOSE:
###   A PowerShell Script to perform bulk test and conversion of folders of App-V 4.x packages to 5.x
###
### AUTHOR:
###   Tim Mangan, TMurgent Technologies, LLP
###
### COPYRIGHT/LICENSE:
###   Copyright 2015, TMurgent Technologies, LLP
###   You are free to use, modify, and redistribute (with attribtuion).  Use of the script is at your own risk.
###
### REQUIREMENTS:
###   Should be run on a machine with the App-V 5.x Sequencer installed.
###   If any of the 4.x packages were created on an x64 OS, whether or not the applciation was 64-bit, this
###   script has to br run in a 32-bit powershell window on an x64 machine.
###   In all cases, you must elevate the powershell window using RunAs.
###   There is no need to have a clean snapshot.
### DESCRIPTION:
###   Given a folder (or list of folders) that conain any kine of sub-folder structure, the script will search
###   for existing sprj files.  It will test the old package to see if it is a reasonable candidate for conversion,
###   and if so run the converter on it.  The output will be in a new folder that is a subfolder of the designated output
###   folder.  The subfolder created for the output will use the package name, with a unique appendix generated in the 
###   case of a conflict.
###
###   The script provides on-screen output of the results, and also copies the results to an output txt file placed in the 
###   output subfolder for converted package.
###
### USAGE:
###   1) If the source of the packages is a remote share, you should mount a drive (inside the elevated PowerShell Window) 
###      to the share location.  This can be preformed such as:
###           new-psdrive -name Z -  \\servername\share -  FileSystem
###   2) Alter the first two non-commented lines this file to desigate the source and destation locations for the packages.
###      While the script will parse all subfolders of a given source, you may have multiple sources.  If so, you would designate
###      the folders using a comma, such as is shown in the SourceBases variable below.
###   3) Run the file (no arguments needed) such as:
###           PowerShell.exe -File ConvertFolderOfOldAppVPackages.ps1
md C:\output
New-PSDrive -name Y -PSProvider FileSystem -Root 'C:\Packages'
New-PSDrive -name z -PSProvider FileSystem -Root 'C:\Output'
#################################################################################################################
$SourceBases =  "Y:", "Z:" 
$DestBase = "C:\Converted"

# Counters used for display
$PackagesToConvert = 0
$PackagesTestError = 0
$PackagesConvertError = 0
$PackagesConvertWarning = 0
$PackagesConverted = 0
$TotalSeconds = 0

write-host -ForegroundColor Green "Initializing."
 
# Gather source packages
$Sources = @()
foreach ($SourceBase in $SourceBases)
{
    $Sourcetmp = (Get-ChildItem -Path $SourceBase -Recurse -Filter "*.sprj" )
    foreach ($tmp in $Sourcetmp)
    {
        $Sources += $tmp
    }
    Write-Host $SourceBase " " $Sourcetmp.Count " " $Sources.Count 
}
Write-Host  -ForegroundColor Green  $Sources.Count " input projects to investigate..."


$i = 1

foreach ($x in $Sources )
{
    if ($x.FullName.EndsWith(".sprj"))
    {
        try
        {
            $dirbase = Get-Item -Path $DestBase -ErrorAction SilentlyContinue
            if ($dirbase -eq $null)
            {
                $tmp = New-Item $DestBase -type directory
            }
        } catch { }

        $start = get-date
        
        $PackagesToConvert += 1
        $ThisPackageTestError = $false
        $ThisPackageTestWarning = $false
        $ThisPackageConvertError = $false
        $ThisPackageConvertWarning = $false
        write-host -ForegroundColor Green "Processing: "  $x.FullName "   " $i " of " $Sources.Count

        $DestPath = $DestBase + "\" + $x.Directory.Name
        try
        {
            $dirfolder = Get-Item -Path $DestPath -ErrorAction SilentlyContinue
            if ($dirfolder -ne $null)
            {
                write-host -ForegroundColor Yellow "Destination " $DestPath " already exists. Processing anyway using _###..."
                $DestPath += "_" + (Get-Random).ToString()
                $tmp = New-Item $DestPath -type directory
                <#  exit  #> 
            }
            else
            {
                $tmp = New-Item $DestPath -type directory
            }
        } catch { }
        
        $osds = Get-ChildItem -Path $x.DirectoryName -Filter "*.osd"
        if ($osds -ne $null)
        {
            write-host -ForegroundColor Green "Located OSDs: "
            foreach ($o in $osds) { write-host -ForegroundColor Green "             " $o.FullName }
        }
        else
        {
            write-host -ForegroundColor Yellow "OSD files not found???" 
        }

        $ResultsOutput = $DestPath + "/ConvertTestOutput.txt"
        get-date | Out-File $ResultsOutput
        Out-File $ResultsOutput -width 120 -Append -InputObject "TEST CONVERSION:"

        try
        {
            $test1 = Test-AppvLegacyPackage -SourcePath $x.DirectoryName -Verbose  -ErrorAction Stop
        }
        catch
        {
            $ThisPackageTestError = $true
            Write-Host -ForegroundColor Red $_.Exception.Message
            Out-File $ResultsOutput -width 120 -Append -InputObject $_.Exception.Message
        }
        $test1
        $test1 | Out-File $ResultsOutput -width 120 -Append

        if ($test1.Errors.Count -ne 0)
        {
            $ThisPackageTestError = $true
        }
        elseif ($test1.Warnings.Count -ne 0)
        {
            $ThisPackageTestWarning = $true
        }

        if ($ThisPackageTestError -eq $false)
        {
            Write-Host -ForegroundColor Green "Attempting Conversion...  " 
            try
            {
                $test2 = ConvertFrom-AppvLegacyPackage -SourcePath $x.DirectoryName -DestinationPath $DestPath -OSDsToIncludeInPackage $osds -ErrorAction Stop
            }
            catch
            {
                $ThisPackageConvertError = $true
                Write-Host -ForegroundColor Red $_.Exception.Message
                Out-File $ResultsOutput -width 120 -Append -InputObject $_.Exception.Message
            }
            $test2
            Out-File $ResultsOutput -width 120 -Append -InputObject "ACTUAL CONVERSION:"
            $test2 | Out-File $ResultsOutput -width 120 -Append
            if ($ThisPackageConvertError -eq $false -and ($test2.Errors.Count -eq 0))
            {
                $PackagesConverted += 1
            }
            else
            {
                $ThisPackageConvertError = $true
            }
            if ($test2.Warnings -ne 0)
            {
                $ThisPackageConvertWarning = $true
            }
        }
        else
        {
            write-host -ForegroundColor Yellow This package will not convert.
        }
        if ($ThisPackageTestError -eq $true)
        {
            $PackagesTestError += 1
        }
        elseif ($ThisPackageConvertError -eq $true)
        {

            $PackagesConvertError += 1
        }
        elseif ($ThisPackageTestWarning -eq $true -or $ThisPackageConvertWarning -eq $true)
        {
            $PackagesConvertWarning += 1
        }
        $end = get-date
        $diff = new-TimeSpan -Start $start -End $end
        $TotalSeconds += $diff.TotalSeconds
        write-host -ForegroundColor Green "Time to process package: " $diff.TotalSeconds " seconds"

        $i += 1
    }
}

# Final counter display
Write-Host
Write-Host -BackgroundColor Green -ForegroundColor Black "           Attempts: " $PackagesToConvert
Write-Host -BackgroundColor Green -ForegroundColor Black "        Test Errors: " $PackagesTestError
Write-Host -BackgroundColor Green -ForegroundColor Black "  Conversion Erorrs: " $PackagesConvertError
Write-Host -BackgroundColor Green -ForegroundColor Black "Convertion Warnings: " $PackagesConvertWarning
Write-Host -BackgroundColor Green -ForegroundColor Black " Converted Packages: " $PackagesConverted
Write-Host -BackgroundColor Green -ForegroundColor Black "    Elapsed Seconds: " $TotalSeconds