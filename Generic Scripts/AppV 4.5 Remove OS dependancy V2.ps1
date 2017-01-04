Get-ChildItem 'C:\UAM\_MassConversion\New Source\New\*.osd' |
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