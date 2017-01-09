function get-DiskSpaceInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   Position=1,
                   HelpMessage='Computername',
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String[]]$computername,

        [Parameter(Position=2)]
        [ValidateSet('Floppy','Local','Optical')]
        [String]$DriveType =  'Local'
    )
    Begin{}
    Process{
        foreach ($computer in $computername) {
            $params = @{ 'ComputerName' = $computer;
                         'Class' = 'Win32_LogicalDisk' }
            switch ($DriveType){
                'Local' {$params.add('Filter','DriveType=3')}
                'Floppy' {$params.add('Filter','DriveType=2')}
                'Optical' {$params.add('Filter','DriveType=5')}
                
            }
            Get-WmiObject @Params |
            Select-Object @{n='Drive';e={$_.DeviceID}},
                          @{n='Size';e={"{0:N2}" -f ($_.Size /1GB)}},
                          @{n='FreeSpace';e={"{0:N2}" -f ($_.FreeSpace / 1Gb)}},
                          @{n='FreePercent';e={"{0:N2}" -f ($_.FreeSpace / $_.Size *100)}},
                          PSComputerName
              
        }              
    }
    End{}
}