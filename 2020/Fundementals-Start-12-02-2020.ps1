



function Move-Files {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,
        HelpMessage = "Source Location to Copy From")]
        [ValidateScript({Test-Path $_ })]
        [string]$SourcePath,
        [Parameter(Mandatory=$True,
        HelpMessage = "Destination to copy to")]  
        [ValidateScript({Test-Path $_ })]
        [string]$DestinationPath
    )
    
    begin {
        
    }
    
    process {

        try {
            Copy-Item -Path $SourcePath -Destination $DestinationPath
        
            }
        catch {

            Write-host "Copy was not successful"
            
        }
        
    }
    
    end {
        
    }
}

Move-Files -SourcePath C:\Git\ps\Desknotes.ps1 -DestinationPath c:\badger
notepad C:\Git\ps\Desknotes.ps1