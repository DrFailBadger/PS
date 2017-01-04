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
                $volumes = Get-CimInstance -Filter "DriveType=$DriveTypeFilter" -ClassName Win32_Volume -ComputerName $Computer -ErrorAction Stop
            } else {
                Write-Verbose "Querying with no filter"
                $volumes = Get-CimInstance -ClassName Win32_Volume -ComputerName $Computer -ErrorAction Stop
            }

            ForEach ($vol in $volumes) {
                switch ($vol.drivetype) {
                    0 { $dt = 'Dunno'      }
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
            Write-Warning "Oh noze! $Computer no bueno!"
        }
    }
}
END { Write-Verbose "Miller time!" }