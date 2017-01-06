$procs = Get-Process

$procs = Get-Process -name notepad 
notepad;notepad;notepad

Get-Process -name notepad | ForEach-Object -Process { $_.Kill() }

Get-Process -name notepad | ForEach { $_.Kill() }
Get-Process notepad | % { $_.Kill() } ##not the fastest performing

Get-Process notepad | Stop-Process ##quicker than for each

Stop-Process -name notepad ###fastest

Measure-Command -?

Measure-Command -Expression { notepad;notepad;notepad; Get-Process -name notepad | foreach { $_.kill() }} ##26 ms
Measure-Command -Expression { notepad;notepad;notepad; Get-Process -name notepad | Stop-Process } ##48 ms
Measure-Command -Expression { notepad;notepad;notepad; Stop-Process -name notepad } ###20 ms

notepad;notepad;notepad

Measure-Command -Expression { Get-Process -name notepad | foreach { $_.kill() }}
Measure-Command -Expression { Get-Process -name notepad | Stop-Process }
Measure-Command -Expression { Stop-Process -name notepad } 

Get-Process -name notepad | % {$PSItem.kill()}

Get-Process -name notepad | % ID
Get-Process -name notepad | select -ExpandProperty id

Get-Process -name notepad | % kill

Get-Process | foreach { $_.name.ToUpper() }
Measure-Command -Expression {Get-Process -name notepad | foreach kill}

















