5 -eq 5
true
5 -ne 10
True
3 -lt 10 
True
5 -ge 5
True
5 -le 10
True
"hello" -eq "hello"
True
"hello" -ne "goodbye"
True
"hello" -eq "HELLO"
True
"Hello" -CEQ "HELLO"
False
#C infront for case match
"Hello" -like "*l*"
True
"hello" -like "*L*"
True
"Hello" -clike "*L*"
FAlse
"Hello" -cnotlike "*L*"
True
"hello" -notlike "*L*"
FAlse

$services = Get-Service

$services[0]
$services[0].Status
$services[0].Status -eq 'Running'
False

Get-Service | Where-Object -FilterScript { $_.status -eq 'Running' } # True carries on down the pipeline false does not
Get-Service | Where-Object -FilterScript { $_.status -eq 'Running' -and $_.Name -like 's*'}
Get-Service | Where-Object -FilterScript { $_.status -eq 'Running' -or $_.Name -like 's*'}
Get-Service | Where-Object -FilterScript { $_.status -eq 'Running' -or $_.Name -like 's*'} | fw
Get-Service | Where-Object -FilterScript { $_.status -eq 'Running' -and $_.Name -like 's*'} | fw

Get-Service | Where { $_.status -eq 'Running' -and $_.Name -like 's*'} | fw
Get-Service | ? { $_.status -eq 'Running' -and $_.Name -like 's*'} | fw
gsv| ? { $_.status -eq 'Running' -and $_.Name -like 's*'} | fw #alias's

Get-Process | select -First 1 -Property *


Get-Process | where { $_.Responding -eq $true } | fw -Property name

Get-Process | where { $_.Responding } | fw -Property name # dont need the true
Get-Process | where { -not $_.Responding } | fw -Property name #-not makes it a false
Get-Process | where { -not $_.Responding } | fw -Property name 

Get-Service | where {  $_.Status -eq 'running' }

Get-Service | where {  $PSItem.Status -eq 'running' } #version 3 psitem same as $_

Get-Service | where status -EQ 'running' #dont need {} - only for single comparision
Get-Service | where status -EQ 'running' | Where-Object name -like 's*' # could pipe another where ontop ##quicker individually
#format as far tothe right
#filter as early as possible to left
## <<-----filter left  Format right ------->





