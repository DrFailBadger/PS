
#$DefaultVMUserName = "Packaging User"
#$DefaultVMPassword = "P4ckag!ng"
#$DefaultSnapShotName = ""
#$DefaultVMXPath = "E:\Windows 7 x64\Windows 7 x64\Windows 7 x64.vmx"


Function Start-VMSnapshots{
    [CmdletBinding()]
    Param(       
                       
        [Parameter(Mandatory=$True,
                   HelpMessage = "-snapshots CreatesSnapshot, DeleteSnapshot,RevertSnapshot")]
        [ValidateSet('CreateSnapshot','DeleteSnapshot','revertToSnapshot')]
        [String]$Snapshots,

        [Parameter(Mandatory=$False,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})]
        [Alias('Path')]
        [String]$VMXpath = $DefaultVMXPath,

        [Parameter(Mandatory=$False,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Snapshotnames")]
        [Alias('Name')]
        [String]$SnapshotName = $DefaultSnapShotName
    )

    BEGIN {}
    PROCESS {
        If(($VMXpath -eq "") -or ($path -eq "")){
            Write-Error '-VMXpath or $DefaultVMXpath must be Set' -ErrorAction Stop
        }
        If($SnapShotName -eq ""){
            Write-Error '-SnapShotName or $DefaultSnapShotName must be Set' -ErrorAction Stop
        }

        [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe" 

        Switch($Snapshots) {
            'CreateSnapshot' { $Snapshots1 = "snapshot" }
            'DeleteSnapshots' { $Snapshots1 = "deleteSnapshot" }
            'RevertToSnapshot' { $Snapshots1= "revertToSnapshot" }
        }

        & "$VMRunexe" -t ws "$Snapshots1" "$vmxPath" "$SnapshotName"
        & "$VMRunexe" -t ws start "$vmxPath"
    }
    END{}
}

Function Copy-VMFolder{
    [CmdletBinding()]
    Param(       
                       
        [Parameter(Mandatory=$False,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})] 
        [Alias('Path')]
        [String]$VMXPath = $DefaultVMXPath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "User Name for Target VMX")]
        [String]$VMUserName = $DefaultVMUserName,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Password for Target VMX")]
        [String]$VMPassword = $DefaultVMPassword,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of file")]
        #[ValidateScript({(Get-Item "$_") -is [System.IO.FileInfo]})] 
        [Alias('PathFrom')]
        [String]$From,

        [Parameter(Mandatory=$True,
                   HelpMessage = "Location of Folder")]
        [Alias('PathTo')]
        [String]$To,

        [Parameter(Mandatory=$False,
        HelpMessage = "Copy File from Host to Guest or Guest to Host")]
        [ValidateSet('HosttoGuest','GuesttoHost')]
        [String]$CopySelection = "HosttoGuest"
        
        )
    Begin{
        If($VMUserName -eq ""){
            Write-Error '-VMUserName or $DefaultVMUserName must be Set' -ErrorAction Stop
        }
        If($VMPassword -eq ""){
            Write-Error '-VMPassword or $DefaultVMPassword must be Set' -ErrorAction Stop
        }
        [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
    }
    Process{

        If($VMXPath -eq ""){
            Write-Error '-VMXPath or $DefaultVMXPath must be Set' -ErrorAction Stop
        }

        #if((Get-Item "$From") -is [System.IO.DirectoryInfo]){
          #  $dir = "$from"
        #}

        $filename = Split-path "$from" -Leaf
        Switch($CopySelection) {
            'HostToGuest' { & "$VMRunexe" -gu "$VMUserName" -gp "$VMPassword" copyFileFromHostToGuest "$VMXPath" "$from" "$To\$filename" }
            'GuesttoHost' { & "$VMRunexe" -gu "$VMUserName" -gp "$VMPassword" copyFileFromGuestToHost "$VMXPath" "$from" "$To\$filename" }
        }
    }

    End{}
}

Function Get-VMSnapshots{
    [CmdletBinding()]
    Param(       
                       
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})] 
        [Alias('Path')]
        [String]$VMXpath = $DefaultVMXPath

    )

    BEGIN {$return =@()}
     
    PROCESS {

        If($VMXpath -eq ""){
            Write-Error '-VMXpath or $DefaultVMXpath must be Set' -ErrorAction Stop
        }


        [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
        [String]$list = "listSnapshots"

        $SnapShotName = & "$VMRunexe" -t ws "$list" "$vmxPath"

        Foreach($item in $SnapShotName){
            $return += New-Object Psobject -Property @{
                Name = $item
                Path = $VMXpath
            }
        }
    }
    END {Return $return}
}
 
Function Get-VMs {

    $LocalVMListlocation = Get-Content "$env:APPDATA\VMware\inventory.vmls"
    [int]$count = ($LocalVMListlocation|Where-Object{($_.Substring(0,11) -match "index.count")}|Foreach{$_ -replace '\D+(\d+)"','$1'}) -1
    $return =@()

    While($count -gt 0){

        $VMName = $LocalVMListlocation|Where-Object{($_.Substring(0,11) -match "index$Count")}|Where-Object{$_ -match ".field0.value = "}|Foreach{(($_ -split ".value = ").Replace("`"",""))[1]}
        $VMPath = $LocalVMListlocation|Where-Object{($_.Substring(0,11) -match "index$Count")}|Where-Object{$_ -cmatch ".id = "}|Foreach{(($_ -split ".id = ").Replace("`"",""))[1]}

        $return += New-Object Psobject -Property @{
            Name = $VMName
            Path = $VMPath
        }

        $count--
    }

    Return $return 

}

Function Invoke-VMCommand {
    [CmdletBinding()]
    Param(       
                      
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of Running VM VMX file")]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})] 
        [Alias('Path')]
        [String]$VMXpath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "User Name for Target VMX")]
        [String]$VMUserName = $DefaultVMUserName,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Password for Target VMX")]
        [String]$VMPassword = $DefaultVMPassword,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Powershell command")]
        [String]$Command,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Powershell command")]
        [ValidateSet('PowerShell','CMD')] 
        [String]$CommandType = "PowerShell",

        [Parameter(Mandatory=$False,
                   HelpMessage = "Powershell command")]
        [String]$PSReturnVariable = '$Return'
    
    )

    <#
    Run a powershell/CMD command on a VM.
    note cmd commands require /C at the beginning e.g.
    /C Notepad.exe
    will load notepad
    Get-RunningVMs| Invoke-VMCommand -Command 'notepad.exe'
    Powershell commands will return variables set as the -PSReturnVariable '$Variableyouwantreturning'
    Powershell return requires Z: drive to be mapped in the virtual machine
    #>
    Begin{
        If($VMUserName -eq ""){
            Write-Error '-VMUserName or $DefaultVMUserName must be Set' -ErrorAction Stop
            $HostPath = $ENV:Temp.Replace(":","")
        }
        If($VMPassword -eq ""){
            Write-Error '-VMPassword or $DefaultVMPassword must be Set' -ErrorAction Stop
        }

        
        switch -wildcard ($CommandType) 
            {           
                "PowerShell" {$Runpath = "$env:windir\system32\windowspowershell\v1.0\PowerShell.exe"
                $Command = "{$PSReturnVariable = ''
                $Command
                IF($PSReturnVariable -ne ''){$PSReturnVariable|Export-Clixml 'Z:\$HostPath\Return.XML'}
                start-sleep 5
                }"
                } 
                "CMD" {$Runpath = "CMD.exe"} 
                }
            }
    Process{
           & "${env:ProgramFiles(x86)}\VMware\VMware VIX\vmrun.exe" -gu "$VMUserName" -gp "$VMPassword" runProgramInGuest "$VMXpath" -interactive -activewindow "$Runpath" "$Command"
    }
    END{
        return Import-Clixml "$ENV:Temp\Return.XML"
            Del "$ENV:Temp\Return.csv"
    }
}

Function Get-RunningVMs {

    [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
    $Paths = (& "$VMRunexe" list)|Select-Object -Skip 1
    $return =@()
    $paths|foreach{
        $return += New-Object Psobject -Property @{
            Path = $_
        }
    }
    Return $return
}

Function Invoke-VMProgram {

    <#
    .SYNOPSIS
    Run program with specified parameters on the target VM

    .DESCRIPTION
    Due to how this command runs against the VMWare Virtual machine, the following two switches have been added by default -interactive -activewindow.
    '-Active Window' Shows the window that is being called on the VM for the User etc.
    '-Interactive' This enables interaction on the VM, this can be useful if the application Errors and you are required to click through the error.

    .PARAMETER VMXpath
    Path the the .vmx file required to be loaded by VMWare. This can be feed in via $DefaultVMXPath for controllers or scripts.

    .PARAMETER VMUserName
    Enter the VM user name you wish to run the command under, note this user needs to be added to the VMX selected in the VMXPath variable. 
    This can be feed in via $DefaultVMUserName for controllers or scripts.

    .PARAMETER ProgramtoRun
    Input the program you wish to run on the VM, this runs from the VM and not the host computers.
    Examples of programs to run, "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe", 'C:\Windows\System32\cmd.exe'
    Note this needs to be the full path to the execuatble and not for example 'PowerShell.exe'.

    .PARAMETER ProgramtoRunParams
    Input the required parameters for the executable you which to run via ProgramToRun variable.
    In the instance of PowerShell this run the commands inside of PowerShell and not against the PowerShell.exe.

    .EXAMPLE

    Example 1:

    First examples are running the Executable only with the -ProgramtoRun param. 
    This enables you to run any executable on the host VM.
    You can also run the exe direclty with Parameters, see below examples. This seems to be the only way to Run PowerShell with a "-file File.ps1" parameter.

        
    Invoke-VMCommandBasic -ProgramtoRun $program

    $program = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" #This would just Run PowerShell and load this on the Screen.
    $program = "C:\Windows\System32\cmd.exe" #Same as the above would just load the cmd Window, as long as the activewindow switch is set.
    $program = '"C:\Windows\System32\cmd.exe" "/k dir C:\"' #Runs a command directly in CMD
    $program = '"C:\Windows\System32\cmd.exe" "/k "C:\packages\install.cmd""' # Run a command against the cmd.exe
    $program = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -file "C:\packages\vmscript.ps1"' #This would install a run a PS against the PowerSell.exe
    $program = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -executionpolicy bypass -file "C:\packages\vmscript.ps1"' #This would install a run a PS against the PowerSell.exe

    Example 2:


    The second examples run the executable in the variable $program and then use the parameters passed to the executable by the -ProgramtoRunParams.
    Not in these examples these are passed in via $Progpram.

    Invoke-VMProgram -ProgramtoRun $program -ProgramtoRunParams $progparam

    $program = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $program = "C:\Windows\System32\cmd.exe"

    $VmBasepath = "C:\packages" #if using variables
    $progparam = "Get-process | export-csv '$VmBasepath\proc.csv'" using above var, running PS command directly on the VM
    $progparam = 'Get-process | export-csv "C:\packages\proc.csv"'Same as above without use of $variable
    $progparam = '/c "C:\packages\install.cmd"' # Runs install.cmd on host VM
    $progparam = '/k dir C:\' Runs CMD command on the host VM

    Another way to add the variables into one command etc

    $Powershell = "`"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`""
    $program1 = "-executionpolicy bypass -file `"C:\packages\vmscript.ps1`""

    $prog = "Powershell $program1"

    Invoke-VMProgram -ProgramtoRun $program

    Example 3:

    Running the function directly with the parameters

    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"'
    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -executionpolicy bypass -file "C:\packages\vmscript.ps1"'
    
    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\cmd.exe"'
    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\cmd.exe"' -ProgramtoRunParams '/k dir C:\'
    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\cmd.exe"' -ProgramtoRunParams '/c "C:\packages\install.cmd"'

    Invoke-VMProgram -ProgramtoRun '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"' -ProgramtoRunParams 'Get-process | export-csv "C:\packages\proc.csv"'
    #> 


    [CmdletBinding()]
    Param(       
                      
        [Parameter(Mandatory=$False,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        #[ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})]
        [Alias('Path')]
        [String]$VMXpath = $DefaultVMXPath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "User Name for Target VMX")]
        [String]$VMUserName = $DefaultVMUserName,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Password for Target VMX")]
        [String]$VMPassword = $DefaultVMPassword,

        [Parameter(Mandatory=$False)]
        [String]$ProgramtoRun,

        [Parameter(Mandatory=$False)]
        [String]$ProgramtoRunParams
    
    )

     Begin{
        If($VMUserName -eq ""){
            Write-Error '-VMUserName or $DefaultVMUserName must be Set' -ErrorAction Stop
           }
        If($VMPassword -eq ""){
            Write-Error '-VMPassword or $DefaultVMPassword must be Set' -ErrorAction Stop
        }
        }

    Process{
        [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
            
        & "$VMRunexe" -gu "$VMUserName" -gp "$VMPassword" runProgramInGuest "$VMXpath" -interactive -activewindow "$ProgramtoRun" "$ProgramtoRunParams"
    }
    END{}
}

Function get-VMRunningProc {

    <#
    .SYNOPSIS
    Checks Running process on the Virtual Machines specified -VMXpath

    .DESCRIPTION
    Same as Synopsis, very simple command

    .PARAMETER VMXpath
    Path the the .vmx file required to be loaded by VMWare. This can be feed in via $DefaultVMXPath for controllers or scripts.

    .PARAMETER VMUserName
    Enter the VM user name you wish to run the command under, note this user needs to be added to the VMX selected in the VMXPath variable. 
    This can be feed in via $DefaultVMUserName for controllers or scripts.


    .EXAMPLE

    Example 1:

    get-VMRunningProc | Where-object{($_ -split "cmd=")[1] -match "Repack.exe"}

    #> 


    [CmdletBinding()]
    Param(       
                      
        [Parameter(Mandatory=$False,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage = "Location of VMX file")]
        #[ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".vmx")})]
        [Alias('Path')]
        [String]$VMXpath = $DefaultVMXPath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "User Name for Target VMX")]
        [String]$VMUserName = $DefaultVMUserName,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Password for Target VMX")]
        [String]$VMPassword = $DefaultVMPassword

    )

     Begin{
        If($VMUserName -eq ""){
            Write-Error '-VMUserName or $DefaultVMUserName must be Set' -ErrorAction Stop
           }
        If($VMPassword -eq ""){
            Write-Error '-VMPassword or $DefaultVMPassword must be Set' -ErrorAction Stop
        }
        }

    Process{
        [string]$VMRunexe = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
            
        & "$VMRunexe" -gu "$VMUserName" -gp "$VMPassword" listProcessesInGuest "$VMXpath"
    }
    END{}
}