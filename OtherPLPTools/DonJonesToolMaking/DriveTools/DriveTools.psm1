Function Get-DriveInfo {
    <#

    .SYNOPSIS
    Gets drive information. Works on remote computers!!

    .DESCRIPTION
    See Synopsis. This isn't complex.

    .PARAMETER ComputerName
    The, uh, computer name. Accepts arrays and pipeline input. Have fun.

    .PARAMETER DriveTypeFilter
    Only query drives of the specified type. Numeric; must be 0-6. See docs
    for Win32_Volume for values and their meanings.

    .EXAMPLE
    Get-DriveInfo -ComputerName DC
    This example gets drive info from the computer named DC.

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name','MachineName','HostName')]
        [string[]]$ComputerName,

        [ValidateRange(0,6)]
        [int]$DriveTypeFilter
    )

    BEGIN { Write-Verbose "Beginning!" }
    PROCESS {

        ForEach ($computer in $ComputerName) {
            Try {
                Write-Verbose "Now attempting $Computer"
            
                if ($PSBoundParameters.ContainsKey('DriveTypeFilter')) {
                    Write-Verbose "Querying with filter for drive type $DriveTypeFilter"
                    $volumes = Get-CimInstance -Filter "DriveType=$DriveTypeFilter" -ClassName Win32_Volume -ComputerName $Computer -ErrorAction Stop -ErrorVariable x
                } else {
                    Write-Verbose "Querying with no filter"
                    $volumes = Get-CimInstance -ClassName Win32_Volume -ComputerName $Computer -ErrorAction Stop -ErrorVariable x
                }

                ForEach ($vol in $volumes) {
                    switch ($vol.drivetype) {
                        0 { $dt = 'Unknown'    }
                        1 { $dt = 'No root'    }
                        2 { $dt = 'Removable'  }
                        3 { $dt = 'LocalFixed' }
                        4 { $dt = 'Network'    }
                        5 { $dt = 'Optical'    }
                        6 { $dt = 'RAM'        }
                    }
                    $vol | Add-Member -MemberType NoteProperty -Name 'DriveKind' -Value $dt
                    $vol | Add-Member -MemberType NoteProperty -Name 'ComputerName' -Value $computer
                    Write-Output $vol
                }
            } Catch {
                Write-Warning "Oh noze! $Computer no bueno! `n`n $x"
                $broken = $true
                $computer | out-file errors.txt -Append
            }
        }
    }
    END {
        Write-Verbose "Miller time!" 
        If ($broken) { Write-Warning "Stuff broke, see errors.txt for list." }
    }
}


Function Set-ServicePassword {
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        [string]$ServiceName,
        [string[]]$ComputerName,
        [string]$NewPassword
    )

    ForEach ($computer in $ComputerName) {
        
        $services = Get-WmiObject -Class Win32_Service -Filter "Name = '$servicename'" -ComputerName $computer
        foreach ($service in $services) {
            
            if ($PSCmdlet.ShouldProcess("$servicename on $computername")) {
                $ErrorActionPreference = "Stop"
                try {
                    $result = $service.Change($null,$null,$null,$null,$null,$null,$null,$newpassword)

                    if ($result.ReturnValue -ne 0) {
                        Write-Warning "Dude, $computer failed failed failed"
                    }
                } catch {
                    # whatever
                } finally {
                    $ErrorActionPreference = "Continue"
                }
            }
        }

    }
}
