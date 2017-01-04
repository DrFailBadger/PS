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


Get-AppV4Variables -Path $path | Sort-Object -Property 'OSDName', 'variable name' -Unique | Select-Object -Property 'AppName', 'OSDName' , 'variable name', 'Variable Path'  | Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 Variables"
Get-AppV4ShortcutDetails -Path $path | Select-Object AppName, OSDName, ShortcutName, Target, Parameters | Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 Shortcut Details" #-Verbose
Get-AppV4FTAs -Path $Path | sort-Object -Property OSDName, FTA -Unique | Select-Object -Property 'AppName', 'OSDName', 'FTA'| Export-NiceCSV -OutPutPath $OutPutPath -FileName "AppV4 FTA"
#Remove-AppV4DependantOS -Path $path

