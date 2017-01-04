$path = 'C:\UAM\_MassConversion\New Source\New\Oracle_Oracle_9i_Client_9.2.0.1_MNT_v1'

Get-ChildItem $path -Recurse -Include '*.osd' |
foreach {
    [Xml]$xml = Get-Content $_.FullName
    $item = Select-XML -Xml $xml -XPath '//SOFTPKG/IMPLEMENTATION/OS'
    $null = $item.Node.ParentNode.RemoveChild($item.Node)
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