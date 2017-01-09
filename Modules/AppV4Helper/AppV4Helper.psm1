Remove-Module AppV4Helper
Import-Module AppV4Helper

$Path = 'C:\UAM\_MassConversion\New Source'
$OutPutPath = 'C:\UAM\_MassConversion\'

#$ExcelExt = '.xlsx'
#$author = 'David Hislop'
#$TableColor = 'Medium'
#$TableNumber = '4'

#$FileName = 'AppV4 Shortcut Details'
#$ShortcutTable = $ShortcutTable | Select-Object AppName, OSDName, ShortcutName, Target, Parameters


Get-OSDs -path $path | Get-AppV4Variables | Sort-Object -Property 'OSDName', 'variable name' -Unique | Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 Variables"
Get-OSDs -path $Path | Get-AppV4ShortcutDetails | Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 Shortcut Details" 
Get-OSDs -Path $Path | Get-AppV4FTAs | sort-Object -Property OSDName, FTA -Unique | Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 FTA"
#Remove-AppV4DependantOS -Path $path

