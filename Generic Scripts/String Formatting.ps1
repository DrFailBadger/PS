# A Basic String
$myString = 'The price of a Beer is $6.00'
Write-Output $myString

# Using String concatination
$myItem = 'Beer'
$myString = 'The price of a ' + $myItem + ' is $6.00'
Write-Output $myString

# Using the format operator
$myItem = 'Beer'
$myPrice = '$6.00'
$myString = 'The price of a {0} is {1}' -f ($myItem,$myPrice)
Write-Output $myString

# Using Variables Inside A String with double quotes
$myItem = 'Beer'
$myString = "The price of a $myItem is $6.00"
Write-Output $myString

# Escaping the dollar sign using a back-tick 
$myItem = 'Beer' 
$myString = "The price of a $myItem is `$6.00" 
Write-Output $myString 

# Create a hash table for the item and use double quotes 
 $myItem = @{ 
    type = 'Beer' 
    price = '$6.00' 
} 
$myString = "The price of a $myItem.type is $myItem.price" ###incorrecct needs subexpression see below
Write-Output $myString 

$myString = "The price of a $($myItem.type) is $($myItem.price)" ###incorrecct needs subexpression see below
Write-Output $myString 
