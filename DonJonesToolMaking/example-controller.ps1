
Write-Host "============================"
Write-Host "       SUPPORT MENU"
Write-Host "============================"
Write-Host ""
Write-Host " 1. Check drive information "
Write-Host "    You will be prompted for a computer name"
Write-Host ""
Write-Host " 2. Kill all processes"
Write-Host ""
$choice = Read-Host "Choose your destiny"

switch ($choice) {
    1 { Write-Host "Running Get-DriveInfo..."; Get-DriveInfo | ft }
    2 { Get-Process | Stop-Process -whatif }
}

Write-Host "Command completed. Re-run ./example-controller.ps1 to re-enter menu."
