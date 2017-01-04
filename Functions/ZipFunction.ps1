
Function Invoke-ZipExtract{
    <#

    .SYNOPSIS
    Extract Zip files to specified location

    .DESCRIPTION
    See Synopsis. This isn't complex.

    .PARAMETER ZipInput
    This can either be a specific .zip file, folder, mix of .zips and folders.
    Each folder will be recursed to look for .zip files and will extract these to the output location.

    .PARAMETER ZipOutput
    This is this location you want the zip files to be extracted to.

    .EXAMPLE

    Invoke-ZipExtract -ZipInput $ZipInput -ZipOutput $ZipOutput
    In this example the two parameters are set to variables in a script.

    Invoke-ZipExtract -ZipInput 'C:\temp\test.zip','C:\temp1\test1.zip', 'C:\folder', 'C:\folder2' -ZipOutput 'C:\output'
    This example shows the input parameter can accept multiple zip's and multiple folder. 
    The folders that entered into the parameter are recursed, any zip files in these folders will be extracted to the output folder.

    #>

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                    HelpMessage = "Folder / Files to Zip")]  
        [string[]]$ZipInput,

        [Parameter(Mandatory=$true,
                    HelpMessage = "Output Location")]  
        [string]$ZipOutput

    )
    #$ZipInput = "C:\MCT\Source\C&W_Thaler2_ELD_2.40.1.9_MNT_v3.zip", "C:\MCT\Zip\NS&I1","C:\MCT\Source\BO_Business_Objects_5.1.7.42_MNT_v1.zip", "C:\packages"
    Add-Type -assembly “system.io.compression.filesystem”
    
    $itemprop = dir -path $ZipInput -Recurse -Include '*.zip' 
    ForEach ($Item in $itemprop) {
        Write-Verbose "Extracting Zip($Item) to $ZipOutput"
        $outfolder= "$ZipOutput\$($item.BaseName)"
        [io.compression.zipfile]::ExtractToDirectory($item, "$outfolder")
    }

}


Function Invoke-ZipArchive{
        <#

    .SYNOPSIS
    Function is to be used to Zip folders to specified output location

    .DESCRIPTION
    See Synopsis. This isn't complex.

    .PARAMETER ZipInput
    Provide location or one or multiple folder to be zip to the output location.

    .PARAMETER ZipOutput
    This is this location you want the zip files to be created.

    .EXAMPLE

    Invoke-ZipArchive -ZipInput $ZipInput -ZipOutput $ZipOutput
    This example has the two parameters set to variables in a script etc.

    Invoke-ZipArchive -ZipInput $ZipInput -ZipOutput $ZipOutput
    This example has the two parameters to variables set in a script.

    Invoke-ZipArchive -ZipInput 'C:\temp\test.zip','C:\temp1\test1.zip', 'C:\folder', 'C:\folder2' -ZipOutput 'C:\output'
    This example shows the input parameter can accept multiple zip's and multiple folder that are recursed and any zip in these folders will be extracted to the output folder.

    #>
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                    HelpMessage = "Folder / Files to Zip")]  
        [string[]]$ZipInput,

        [Parameter(Mandatory=$true,
                    HelpMessage = "Output Location")]  
        [string]$ZipOutput
       
    )

    
    #$ZipInput = "C:\MCT\Source\C&W_Thaler2_ELD_2.40.1.9_MNT_v3.zip", "C:\MCT\Zip\NS&I1","C:\MCT\Source\BO_Business_Objects_5.1.7.42_MNT_v1.zip", "C:\packages"
    Add-Type -assembly “system.io.compression.filesystem”
    
    ForEach ($item in $ZipInput) {

        $Item1 = Get-Item "$item"
        If ($item1 -is [System.IO.DirectoryInfo]){
            $outfoldername = "$ZipOutput\$($item1.name).zip"
            [io.compression.zipfile]::CreateFromDirectory($item1, $outfoldername)
        } Else { 
            Write-Warning 'Provide folder to Zip'
        }
        
    }
}




#$ZipInput = 'C:\NSIBEN\dave', 'C:\NSIBEN\dd'
#$ZipOutput = 'C:\NSIBEN\Packages\New folder'

#Invoke-ZipArchive -ZipInput $ZipInput -ZipOutput $ZipOutput

#$ZipInput = 'C:\NSIBEN\Packages\New folder'
#$ZipOutput = 'C:\NSIBEN\Packages\New folder\New folder'

#Invoke-ZipExtract -ZipInput $ZipInput -ZipOutput $ZipOutput
#$ZipInput = $Path3
#$ZipInput.basename
$Path3 = dir 'C:\UAM\_MassConversion\Temp Source'
$path4 =  'C:\UAM\_MassConversion\New Zip'
Invoke-ZipArchive -ZipInput $Path3.fullname -ZipOutput $path4
