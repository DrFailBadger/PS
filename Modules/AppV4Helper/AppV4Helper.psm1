
Function Remove-AppV4DependantOS{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   HelpMessage = "Path to Folder to Recurse")]  
        [string[]]$Path
       
    )
    Get-ChildItem $path -Recurse -Include '*.osd' |
    foreach {
        [Xml]$xml = Get-Content $_.FullName
        $item = Select-XML -Xml $xml -XPath '//SOFTPKG/IMPLEMENTATION/OS'
        $null = $item.Node.ParentNode.RemoveChild($item.Node)
        $xml.Save($_.FullName)
    }
}

Function Get-AppV4ShortcutDetails{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   HelpMessage = "Path to Folder to Recurse")]  
        [string[]]$Path
       
    )

    #$ShortcutTable = @()
    $Path = 'C:\UAM\_MassConversion\New Source'
  
    Get-ChildItem $Path -Recurse -Include *.osd* |
    foreach{
            [Xml]$xml = Get-Content $_.FullName
            $Shortcut = $xml.SOFTPKG.name
            #$badger = $_.Directory
            $Target = $xml.SOFTPKG.IMPLEMENTATION.CODEBASE.FILENAME
            $Parameters = $xml.SOFTPKG.IMPLEMENTATION.CODEBASE.PARAMETERS
            [array]$ShortcutTable += New-Object PsObject -Property @{ AppName = $($_.Directory).name ; OSDName = "$($_.name)" ; ShortcutName = "$Shortcut"; Target ="$Target" ; Parameters ="$Parameters"}
    }
    $ShortcutTable
}

Function Get-AppV4Variables{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   HelpMessage = "Path to Folder to Recurse")]  
        [string[]]$Path
       
    )
    #$VariableTable =@()

    Get-ChildItem $path -Recurse -Include '*.osd' |
    foreach {
        [Xml]$xml = Get-Content $_.FullName
        $item = Select-XML -Xml $xml -XPath '//SOFTPKG/IMPLEMENTATION/VIRTUALENV/ENVLIST/ENVIRONMENT'
        $AppName = $($_.Directory).name
        $OSDName = $_.name
        $item.Node| % {  [array]$VariableTable += New-Object PsObject -Property @{AppName = $AppName ; OSDName = $OSDName ;'Variable Name' = $_.VARIABLE ; 'Variable Path' = $_.'#text' }}
       
    }
   $VariableTable
}

Function Get-AppV4FTAs{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   HelpMessage = "Path to Folder to Recurse")]  
        [string[]]$Path
       
    )
    #$FTATable = @()
    
    #$Path = 'C:\UAM\_MassConversion\New Source\New\Oracle_Oracle_9i_Client_9.2.0.1_MNT_v1'
    Get-ChildItem $path -Recurse -Include '*.osd' |
    foreach{
        [Xml]$xml = Get-Content $_.FullName
        $AppName = $($_.Directory).name
        $OSDName = $_.name
        $item = Select-XML -Xml $xml -XPath '//SOFTPKG/MGMT_FILEASSOCIATIONS/FILEEXTENSIONLIST/FILEEXTENSION'
        $item.Node | Select-Object -Property ext | % {[Array]$FTATable += New-Object PsObject -Property @{AppName = $AppName ; OSDName = $OSDName ; FTA = $_.Ext}}
                
    }
    $FTATable
}

Function Export-NiceCSV{
    [CmdletBinding()]
    Param( 
    
        [Parameter(Mandatory=$false,
                  ValueFromPipeline=$True,
                  ValueFromPipelineByPropertyName=$True,
                  HelpMessage = "Path file saved to")]
                  #[Alias('data')]
        [psobject]$InputObject,      
                       
        [Parameter(Mandatory=$False,
                   #ValueFromPipeline=$True,
                   #ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Path file saved to")]
        [String]$OutPutPath,
        
        [Parameter(Mandatory=$True,
                   HelpMessage = "File Name and Sheet Name")]
        [String]$FileName,
        
        [Parameter(Mandatory=$False,
                   HelpMessage = "Table format color")]
        [ValidateSet('Light','Medium','Dark')]
        [String]$TableColor = 'Medium',

        [Parameter(Mandatory=$False)]
        [String]$TableNumber = '2',

        [Parameter(Mandatory=$False)]
        [String]$author = 'David Hislop',

        [Parameter(Mandatory=$False)]
        [String]$ExcelExt = '.xlsx'
    )
   # BEGIN {}
    #Write-Verbose $InputObject}
    PROCESS {
    [array]$dataInputObject += $InputObject 
    #[psobject]$data = $Inputobject #| Sort-Object AppName, OSDName, ShortcutName, Target, Parameters
 
    
    }
    END{
    $excelFile = ("$OutPutPath" + (Get-Date -format ddmmyyyy) + "-$FileName$ExcelExt")

    Switch($TableColor) {
        'Light'  { $TableColor1 = "Light" }
        'Medium' { $TableColor1 = "Medium" }
        'Dark'   { $TableColor1 = "Dark" }
    }


    $temporaryCsvFile = ($env:temp + "\" + ([System.Guid]::NewGuid()).ToString() + ".csv")
    $dataInputObject | Export-Csv -path $temporaryCsvFile -noTypeInformation
 
    if(Test-Path -path $excelFile) { Remove-Item -path $excelFile }
 
    $excelObject = New-Object -comObject Excel.Application
    $excelObject.Visible = $false 
 
    $workbookObject = $excelObject.Workbooks.Open($temporaryCsvFile) 
    $workbookObject.Title = ("-AppV4 Shortcut Details " + (Get-Date -Format D))
    $workbookObject.Author = "$author"
 
    $worksheetObject = $workbookObject.Worksheets.Item(1) 
    $worksheetObject.UsedRange.Columns.Autofit() | Out-Null
    $worksheetObject.Name = "$FileName"
 
    $listObject = $worksheetObject.ListObjects.Add([Microsoft.Office.Interop.Excel.XlListObjectSourceType]::xlSrcRange, $worksheetObject.UsedRange, $null,[Microsoft.Office.Interop.Excel.XlYesNoGuess]::xlYes,$null)
    $listObject.Name = "User Table"
    $listObject.TableStyle = "TableStyle$TableColor1$TableNumber" # Style Cheat Sheet in French/English: http://msdn.microsoft.com/fr-fr/library/documentformat.openxml.spreadsheet.tablestyle.aspx
 
    $workbookObject.SaveAs($excelFile,51) # http://msdn.microsoft.com/en-us/library/bb241279.aspx
    $workbookObject.Saved = $true
    $workbookObject.Close()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbookObject) | Out-Null
 
    $excelObject.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excelObject) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers() 
 
    if(Test-Path -path $temporaryCsvFile) { Remove-Item -path $temporaryCsvFile }
    }
}


#$Path = 'C:\UAM\_MassConversion\New Source'
#$OutPutPath = 'C:\UAM\_MassConversion'

#Get-AppV4Variables -Path $path | Sort-Object -Property 'appname', 'variable name' -Unique | Select-Object -Property 'appname', 'variable name', 'Variable Path'  | Export-Csv "$OutPutPath\AppV4 Variables.csv"
#Get-AppV4ShortcutDetails -Path $path | Export-csv "$OutPutPath\Shortcutsdetails.csv"
#Get-AppV4FTAs -Path $Path |Select-Object -Property Appname, FTA -Unique| Export-Csv "$OutPutPath\AppV4 FTAs.csv"
#Remove-AppV4DependantOS -Path $path
