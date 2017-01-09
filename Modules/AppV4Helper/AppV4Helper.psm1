Function Get-OSDs{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = "Path to Folder to Recurse")]  
       [string[]]$Path
    )
  
    Process{
        Get-ChildItem $Path -Recurse -Include '*.osd'
    }
}

Function Remove-AppV4DependantOS{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = "Path to Folder to Recurse")]  
       [System.IO.FileInfo[]]$OSDPath
       
    )

    BEGIN {}
    Process{
       
        foreach ($osd in $OSDPath){
            [Xml]$xml = Get-Content $osd.FullName
            $xml.SelectNodes('//SOFTPKG/IMPLEMENTATION/OS') |  % {$_.ParentNode.RemoveChild($_)}    
            $xml.Save($osd.FullName)
        }

    } 
    End{}
}

Function Get-AppV4ShortcutDetails{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = "OSD's from Path")]  
       [System.IO.FileInfo[]]$OSDPath
       
    )

    BEGIN {}
    Process{

        foreach ($osd in $OSDPath){ 
    
            [Xml]$xml = Get-Content $osd.FullName

            $props = [ordered]@{'AppName' = ($osd.Directory).name
                                'OSDName' = $osd.Name
                                'ShortcutName' = $xml.SOFTPKG.name
                                'Target' = $xml.SOFTPKG.IMPLEMENTATION.CODEBASE.FILENAME
                                'Parameters' = $xml.SOFTPKG.IMPLEMENTATION.CODEBASE.PARAMETERS
                    }
            [Array]$ShortcutTable += New-Object PsObject -Property $props
    
        }
    }
    End{Write-Output $ShortcutTable}
}

Function Get-AppV4Variables{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = "OSD's from Path")]  
       [System.IO.FileInfo[]]$OSDPath
       
    )

    BEGIN {}
    Process{

        foreach ($osd in $OSDPath){ 

            [Xml]$xml = Get-Content $osd.FullName
            $item = Select-XML -Xml $xml -XPath '//SOFTPKG/IMPLEMENTATION/VIRTUALENV/ENVLIST/ENVIRONMENT'

            #$item.Node
            ForEach ($VT in $item.node){
               
                $props = [ordered]@{'AppName' = ($osd.Directory).name
                                    'OSDName' = $osd.Name
                                    'Variable Name' = $vt.VARIABLE
                                    'Variable Path' = $vt.'#text'
                                    }

                [array]$VariableTable += New-Object PsObject -Property $props

                }
            }
        }

    END{Write-Output $VariableTable}
   
}

Function Get-AppV4FTAs{

    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = "OSD's from Path")]  
       [System.IO.FileInfo[]]$OSDPath
       
    )

    BEGIN {}
    Process{
        #[System.IO.FileInfo[]]$OSDPath = 'C:\UAM\_MassConversion\New Source\Snap_Surveys_Snap_9_Pro_9.19.0.0_MNT_v1\Snap 9 Professional 9.19.0.0.osd'
        foreach ($osd in $OSDPath){
            [Xml]$xml = Get-Content $osd.FullName
            $item = Select-XML -Xml $xml -XPath '//SOFTPKG/MGMT_FILEASSOCIATIONS/FILEEXTENSIONLIST/FILEEXTENSION'
            $IT = $item.Node | Select-Object -Property ext
            ForEach ($VT in $IT){
               
                $props = [ordered]@{'AppName' = ($osd.Directory).name
                                    'OSDName' = $osd.Name
                                    'FTA' = $VT.Ext                                   
                                    }

                [array]$FTATable += New-Object PsObject -Property $props
            
            }
        }
    }
    END{Write-Output $FTATable}  
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
