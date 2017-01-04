dir Variable:
$var = 'hello'
dir variable:
Get-Command -Noun variable

New-Variable -name $var -Value 'goodbye'
New-Variable -name var1 -Value 'goodbye'
$hello
$var1
New-Variable -name $var1 -Value 'inside'
$goodbye
$tgus_is_ok = 5
${this is also ok} = 5
$var = 'hello'
$a = "say $var"
$B = 'say $var'

get-help *Variable*