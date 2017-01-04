Get-ChildItem 'C:\UAM\_MassConversion\New Source\Oracle_Forms_And_Reports_6i_PDS_6.0.8.8_MNT_v1 - Copy\*.osd' |
foreach {
    [Xml]$xml = Get-Content $_.FullName
    $parent_xpath = '/SOFTPKG/IMPLEMENTATION'
    $nodes = $xml.SelectNodes($parent_xpath)
    $nodes | foreach {
        $child_node = $nodes.SelectSingleNode('OS')
        $_.RemoveChild($child_node) | Out-Null
    }

    $xml.Save($_.FullName)
}

Function Get-AppV4ShortcutDetails{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   HelpMessage = "Path to Folder to Recurse")]  
        [string[]]$Path
       
    )

    $ShortcutTable = @()
    $Path = 'C:\UAM\_MassConversion\New Source'

    Get-ChildItem $Path -Recurse -Include *.osd* |
    foreach{
            [Xml]$xml = Get-Content $_.FullName
            $Shortcut = $xml.SOFTPKG.name
            $Target = $xml.SOFTPKG.IMPLEMENTATION.CODEBASE.FILENAME
            $ShortcutTable += New-Object PsObject -Property @{ AppName = "$($_.name)"; ShortcutName = "$Shortcut"; Target ="$Target"}
    }
    $ShortcutTable | Select-Object -Property AppName, ShortcutName, Target
}


$ShortcutTable | Select-Object -Property ShortcutName, Target | Export-Csv 'C:\uam\Shortcutsdetails.csv'
Get-AppV4ShortcutDetails -Path 'C:\UAM\_MassConversion\New Source' | Export-csv C:\uam\Shortcutsdetails.csv