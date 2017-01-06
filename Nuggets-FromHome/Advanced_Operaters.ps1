$X ='hello'
$x -is [string]
$x -is [int]

$x -as [int]

56.888899 -as [int]
$x = "5555"
$x -is [string]

$x -as [int]

$y = $x -as [int]
$y -is [int]
$y -isnot [string]

$x = 'powershell'
$x -like '*shell'

$x -contains "Shell"

$x = 1,2,3,4,5,6,'one','two','three'

$x -contains 'two'
true
$x -notcontains 'sever'
true
7 -in $x #ps 3
flase
$x ='powershell'
$x -replace 'l','x'
Powershexx ## this does not replace the original
$x # still = powershell

$arr= 1,2,3,4,5,6,7,8

$arr[0]

$arr+= "one","two","Three" #adds to array
$arr =$arr + "four","five","six" #same as above
$arr -join ',' # makes 1 string and puts comma between each one

$arr # original array still same

$list = $arr -join ',' #simple string
$list[1]#2nd char = ,

$a = $list -split ','
$arr = ,1 #set array but only 1 item
$x =10
$x += 10
$X #is now 20

$s ='hello'
$s += 'there'
$s #concatinates Hellothere

$x++ #adds one
$x-- #substracts one

$x = $X +1
##0-255   -band
#### 1 2 4 8 16 32 64 128 #### each bit in a byte
#### 1 1 1 0 0  0  0  0   #### = 7
#### 0 1 0 1 0  0  0  0   #### = 10   -band
#### 0 1 0 0 0  0  0  0   #### = 2
     # 1's match
7 -band 10
2



#### 1 2 4 8 16 32 64 128 #### each bit in a byte
#### 1 1 1 0 0  0  0  0   #### = 7
#### 0 1 0 1 0  0  0  0   #### = 10   -bor
#### 1 1 1 1 0  0  0  0   #### = 15
#if any colum has 1 in

7 -bor 10
15

#### 1 2 4 8 16 32 64 128 #### each bit in a byte
#### 1 1 1 0 0  0  0  0   #### = 7
#### 0 1 0 1 0  0  0  0   #### = 10   -bxor
#### 1 0 1 1 0  0  0  0   #### = 13
#if any colum only has a 1 in and 

7 -bxor 10
13


help about_Operators
help about_*
help *about*

(5 -gt 1) -and (5-lt 10)
True
(5 -gt 1) -and (5-lt 1) ##either
False
(5 -gt 1) -or (5-lt 10) ##true 1 or other or both true
True
(5 -gt 1) -xor (5-lt 10)
False
(5 -gt 1) -xor (5-lt 10) #xor false if both true, false if both false, true if one or other true

#####Truth Table

And    True  False

True 

False

#-not # replaces operater ## changes false to true etc.

Get-Alias


Dir > DIR.txt
Dir | Out-File -Append #add properties on

dir >> error.txt ## errorss

1..100 #creates all objects inbetween
1..49 | Get-Random

1..100 | ForEach-Object {} ## range operator

"{0} {1:N2} {3} {2:n4}" -f "hello", 4.5566656,456565656,"there" ###formating

######### . sourcing

Set-ExecutionPolicy RemoteSigned -force









