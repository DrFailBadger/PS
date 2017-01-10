$error[0].invocationinfo
$error
Dir Variable:
$error.Clear()
Get-Content ssssss.txt, badger.txt -ErrorVariable x
$error[0] | GM
$x | GM
TRY{

    do-something -ea stop -errorvariable x
} Catch {
    $_
    $error[0]
    $Z = $_
    do-somethingelse
}

foreach ($E in $X) {$E.invocationinfo}


TRY{

    do-something -ea stop -errorvariable x
} Catch {
    $_
    $error[0]
    $Z = $_
    $X.ErrorRecord # Cmdlet
    do-somethingelse
}

#advance functions threw a terminating exeption
$x[0]

#cmdlet threw terminating exception
$X[0].ErrorRecord

#Advanced function threw non-terminating, but you used -ea stop
$X[0].ErrorRecord

#cmdlet threw non-terminating, but you used -ea stop
$x[0].ErrorRecord


#any of these... can be hijacked in catch loop
$_
$error[0]
#set them so not to be hijacked

$Z = $_
$z = $error[0]


$? # true if command completed successfully # false if errored