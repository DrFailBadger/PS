Function Get-IniContent {  
     
    [CmdletBinding()]  
    Param(  
        [ValidateNotNullOrEmpty()]  
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".ini")})]  
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]  
        [string]$FilePath  
    )  
      
    Begin  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started"}  
          
    Process  
    {  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Processing file: $Filepath"  
              
        $ini = @{}  
        switch -regex -file $FilePath  
        {  
            "^\[(.+)\]$" # Section  
            {  
                $section = $matches[1]  
                $ini[$section] = @{}  
                $CommentCount = 0  
            }  
            "^(;.*)$" # Comment  
            {  
                if (!($section))  
                {  
                    $section = "No-Section"  
                    $ini[$section] = @{}  
                }  
                $value = $matches[1]  
                $CommentCount = $CommentCount + 1  
                $name = "Comment" + $CommentCount  
                $ini[$section][$name] = $value  
            }   
            "(.+?)\s*=\s*(.*)" # Key  
            {  
                if (!($section))  
                {  
                    $section = "No-Section"  
                    $ini[$section] = @{}  
                }  
                $name,$value = $matches[1..2]  
                $ini[$section][$name] = $value  
            }  
        }  
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Finished Processing file: $FilePath"  
        Return $ini  
    }  
          
    End  
        {Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended"}  
} 



$wshell = New-Object -ComObject Wscript.Shell
$ScriptError = 0

$registryPath = "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Callataÿ & Wouters\Thaler"
$registryPathHKCU = "Registry::HKEY_CURRENT_USER\Software\Callataÿ & Wouters\Thaler"

$ThalerENV = (Get-ItemProperty -Path $registryPath -Name envreg -ErrorAction SilentlyContinue).envreg 

$renameVar1 = "ZZZZZZ"
$ServerAppData =(Get-ItemProperty -Path $registryPath -Name ServerAppDatareg -ErrorAction SilentlyContinue).ServerAppDatareg

#Rename Regkeys cretaed in Seq
DIR -Path $registryPathHKCU | Where-Object -Property Name -Match $renameVar1 | Rename-Item -NewName $ThalerENV
DIR -Path $registryPath | Where-Object -Property Name -Match $renameVar1 | Rename-Item -NewName $ThalerENV


#New-Item -path $registryPath -name $ThalerENV -Force -ErrorAction SilentlyContinue
$RegKeyEnv = "$registryPath\$ThalerENV"
$FileContentPCIDENT = Get-IniContent "$ServerAppData\Thaler_ID.ini"

if(($($FileContentPCIDENT["UserPINs"]) -ne $null) -and (($FilecontentPCIDENT["UserPINs"]["$env:USERNAME"]) -ne $null))
{
    $PCIDent = $FilecontentPCIDENT["UserPINs"]["$env:USERNAME"]
    $FileContentSTATUS = Get-IniContent "$ServerAppData\SystemStatus.ini"
    $SystemStatus = $FileContentSTATUS["SystemStatus"]["InfrastructureMode"]
}
else
{
    $wshell.Popup("Unable to find your user PIN in the Thaler_ID.ini file. Please contact the helpdesk for support. Aborting program. Click OK to exit.",0,"Unidentified User", 0x30)
    $ScriptError = 1
}


If($SystemStatus -eq "Normal")

{
    $FileContentNomralINI = Get-IniContent "$ServerAppData\Thaler_v2_Normal.ini"
    if($($FileContentNomralINI["$ThalerENV"]) -ne $null)
        {
            $HostAddress = $FileContentNomralINI["$ThalerENV"]["HOSTADDRESS"]
            $HostPort = $FileContentNomralINI["$ThalerENV"]["HOSTPORT"]
            $ResourcePath = $FileContentNomralINI["$ThalerENV"]["RESOURCEPATH"]
        }
    else
        {
        If ($ScriptError -ne 1)
            {
                $wshell.Popup("Environment not found within `"Thaler_V_Normal.ini`" please contact the helpdesk for support. Aborting program. Click OK to exit.",0,"Environment Not Found",0x30)
                $ScriptError = 1
            }
        }
}

elseif($SystemStatus -eq "DR")
{
    $FileContentDRINI = Get-IniContent "$ServerAppData\Thaler_v2_DR.ini"
    if($($FileContentDRINI["$ThalerENV"]) -ne $null)
        {
            $HostAddress = $FileContentDRINI["$ThalerENV"]["HOSTADDRESS"]
            $HostPort = $FileContentDRINI["$ThalerENV"]["HOSTPORT"]
            $ResourcePath = $FileContentDRINI["$ThalerENV"]["RESOURCEPATH"]
        }
        else
        {
        If ($ScriptError -ne 1)
            {
                $wshell.Popup("Environment not found within `"Thaler_V_DR.ini`"please contact the helpdesk for support. Aborting program. Click OK to exit.",0,"Environment Not Found",0x30)
                $ScriptError = 1
            }
        }
}
Elseif($SystemStatus -eq $null)
{
    If ($ScriptError -ne 1)
        {
            $wshell.Popup("Unable to determine the Infrastructure Mode of the system.`n Is it `"Normal`" or `"DR`"? Please check the SystemStatus.ini file and correct this. Aborting program. Click OK to exit.",0,"System State Not Known",0x30)
            $ScriptError = 1
        }
}

If ($ScriptError -eq 0)
{

    New-ItemProperty -Path $RegKeyEnv -Name "HostAddress" -Value "$HostAddress" -PropertyType String -Force | Out-Null  
    New-ItemProperty -Path $RegKeyEnv -Name "HostPort" -Value "$HostPort" -PropertyType String -Force | Out-Null  
    New-ItemProperty -Path $RegKeyEnv -Name "PathMenuBar" -Value "$ResourcePath\$ThalerENV\Menu" -PropertyType String -Force | Out-Null  
    New-ItemProperty -Path $RegKeyEnv -Name "PathMenuTree" -Value "$ResourcePath\$ThalerENV\Menu" -PropertyType String -Force | Out-Null  
    New-ItemProperty -Path $RegKeyEnv -Name "PathXML" -Value "$ResourcePath\$ThalerENV" -PropertyType String -Force | Out-Null 
    
    New-ItemProperty -Path $registryPathHKCU -Name "PCIdent" -Value "$PCIDent" -PropertyType String -Force | Out-Null


    $ThalerExePath = "${env:ProgramFiles(x86)}\Thaler\Thaler 2.40.19\Thaler.exe"
    

    Start-Process -FilePath $ThalerExePath -ArgumentList $ThalerENV -WorkingDirectory "$ResourcePath\$ThalerENV"
}
