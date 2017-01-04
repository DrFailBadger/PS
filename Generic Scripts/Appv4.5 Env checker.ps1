$path = dir 'C:\UAM\_MassConversion\New Source\Oracle_Forms_And_Reports_6i_PDS_6.0.8.8_MNT_v1'

$Returnval =@()

foreach($item in $path){

    $OSD1 = gci $item.FullName -Recurse | Where-Object {$_.Extension -eq '.osd'}
    foreach ($SingleOSD in $OSD1){
        [XML]$singleosdcontent = $SingleOSD | Get-Content
        If ($singleosdcontent.SOFTPKG.IMPLEMENTATION.VIRTUALENV.ENVLIST.ENVIRONMENT -ne $null){
            $Env = $singleosdcontent.SOFTPKG.IMPLEMENTATION.VIRTUALENV.ENVLIST.ENVIRONMENT
            foreach ($Variablename in $Env){
                $Returnval += New-Object PsObject -Property @{ AppName = "$($item.name)"; EnvironmentVariable = "$($Variablename.'variable')" ; EnvironmentalPath = "$($Variablename.'#text')"}  
            }
        }
        if($singleosdcontent.SOFTPKG.MGMT_FILEASSOCIATIONS.FILEEXTENSIONLIST.ChildNodes -ne $null){
            $FTA = $singleosdcontent.SOFTPKG.MGMT_FILEASSOCIATIONS.FILEEXTENSIONLIST.ChildNodes | Select-Object -Property ext
            foreach ($ext in $FTA){
                $Returnval += New-Object PsObject -Property @{ AppName = "$($item.name)"; FileType = "$($ext.'ext')"}  
            }
        }

    }
     
}

$Returnval | Sort-Object "appname","EnvironmentVariable" -Unique | Select-Object -Property AppName, EnvironmentVariable, EnvironmentalPath, FileType |Sort-Object filetype -Descending | Export-Csv -Delimiter ',' 'C:\uam\uam.csv'

#$Returnval | Select-Object -Property AppName, EnvironmentVariable, EnvironmentalPath, FileType |Sort-Object 'appname', 'filetype' -Unique | Export-Csv -Delimiter ',' 'C:\uam\fta.csv'

#$unique = $Returnval.appname |Get-Unique EnvironmentVariable
#$finalarray = @() 
#foreach($item in $unique){ 
#    $finalarray += $Returnval |Where-Object -Property "AppName" -eq "$item"|Sort-Object -Property "EnvironmentVariable" -Unique 
#} 

#$finalarray | Select-Object -Property AppName,EnvironmentVariable,EnvironmentalPath,FileType |Sort-Object filetype -Descending > C:\uam\