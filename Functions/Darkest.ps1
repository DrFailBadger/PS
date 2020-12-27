$ProcessList = @(
    "Darkest" #or whatever you want to monitor
)
$path = 'C:\Program Files (x86)\Steam\userdata\24510301'
Do {  
    $ProcessesFound = Get-Process | ? {$ProcessList -contains $_.Name} | Select-Object -ExpandProperty Name
    If ($ProcessesFound) {
        Write-Host "Still running: $($ProcessesFound)"
        $Date = Get-Date -Format dd-MM_HH-mm
        Copy-Item $path -recurse -Container -Destination $path-1-$date -force
        Start-Sleep 600
       
    }
} Until (!$ProcessesFound)
