
Function ExpandAppV4{

    Param(  
     
            [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".sprj")})]  
            [Parameter(Mandatory=$True)]  
            [string]$SPRJName  

        )



    [String]$SeqLocation = & 'C:\Program Files\mic'


&. "$SeqLocation /Expand:$SPRJName"

}

 Out-File -FilePath "$a\Connection1.xml" -Encoding ascii -Force  


