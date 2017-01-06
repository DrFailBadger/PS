$Path2 = 'C:\Users\A175112\Desktop\Compat'

$Path = Dir 'C:\Users\A175112\Desktop\Errors' -Recurse -Include "*.pdf" |

foreach{
    Move-Item $_.FullName -Destination $Path2
}


