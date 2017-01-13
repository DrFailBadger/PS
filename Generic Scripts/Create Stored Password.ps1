read-host -assecurestring | convertfrom-securestring | out-file C:\uam\username-password-encrypted.txt
$username = "Packaging"
$password = cat C:\uam\username-password-encrypted.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

