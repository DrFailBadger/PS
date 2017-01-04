Param(  
     
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".appv")})]  
        [Parameter(,Mandatory=$True)]  
        [string]$AppVPackagePath  

    )

Expand-AppvSequencerPackage -AppvPackagePath $AppVPackagePath 