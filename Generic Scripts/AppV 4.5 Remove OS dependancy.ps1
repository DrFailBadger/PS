$path = dir 'C:\UAM\_MassConversion\New Source\New' | Where-Object {$_.Extension -eq '.osd'}

#$path = dir 'C:\UAM\_MassConversion\New Source\Oracle_Forms_And_Reports_6i_PDS_6.0.8.8_MNT_v1'

foreach($item in $path){}
    [XML]$XML = $Item | Get-Content
    $xml.SOFTPKG.IMPLEMENTATION.OS
    #$singleosdcontent.SOFTPKG.IMPLEMENTATION.OS
    While ($node -ne $null){
        $node = $XML.SelectSingleNode("//OS")
        $node.
        $node = $singleosdcontent.SelectSingleNode("//OS")
    }
    $singleosdcontent.Save($item.FullName)
# }   

