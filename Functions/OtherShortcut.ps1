function Get-ShortcutDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
        Position=1,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        HelpMessage='Gets Shortcut Details')]
        $Shortcut
        
    )
    
    begin {
        $sh = New-Object -ComObject WScript.Shell
        [Array]$Props =$null
    }
    
    process {
        
        #foreach ($lnk in $Shortcut) {}
            $lnk1 = $sh.CreateShortcut($Shortcut.FullName) 
            if ($lnk1.IconLocation -eq ",0") {
                $IconLocation = $lnk1.TargetPath + $lnk1.IconLocation
            }Else{
                $IconLocation = $lnk1.IconLocation
            }
            $Props += [Ordered]@{
                'New Shortcut'      =   ""
                Name                =   $Shortcut.BaseName
                'StartMenu Location'=   $Shortcut.DirectoryName
                'Full Path'         =   $lnk1.FullName
                'Target Path'       =   $lnk1.TargetPath
                Arguments           =   $lnk1.Arguments
                'Working Directory' =   $lnk1.WorkingDirectory
                'Icon Location'     =   $IconLocation
                Description         =   $lnk1.Description

            }
           
            #$props
            
        #}
    }
    
    end {
        Write-Output $props
    }
}