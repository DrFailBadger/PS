Get-Service
#collection of objects, each row is object, the first colum is property
google the typename
Get-service | gm

Get-Process | gm -View All
Get-Process | gm -View Adapted
Get-Process | gm -View Base
Get-Process | gm -View Extended
$x = 'hello' 
$x | GM
$x.Length 

$x.Replace('ll','xx')
$X
$x.ToUpper()
$x.ToLower()
Get-Command -name *date*
$C = Get-Date
$c.DayOfWeek
$C.Ticks
$C.ToShortDateString()
$c.AddDays(90)
$c.AddDays(-90)
$c.AddDays(-90).Year
$c.AddDays(-90).ToShortDateString() | gm #is now system string

$procs = Get-Process -name notepad
$procs[0] | gm
$procs[0].CPU | gm
$procs[0].PM | gm
$procs[0].Kill()
$procs #still has all three notepads










