$Path = 'C:\Users\A175112\Desktop\Errors'

$Path2 = 'C:\Users\A175112\Desktop\Compat'

$dave = Dir $Path -Recurse | Where-Object {$_.Extension -eq '.pdf'}

foreach ($item in $dave){
    Move-Item $item.FullName -Destination $Path2
}

$path3 = 'C:\Users\A175112\Desktop\Compat'

