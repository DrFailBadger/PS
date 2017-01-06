# Import the NetAdapter module. This step is provided for clarity. It is not needed due to the new module autoloading feature in Windows PowerShell 3.0

Import-Module NetAdapter 

# Retrieve the network adapter that you want to configure.

$netadapter = Get-NetAdapter -Name Ethernet

 # Disable DHCP.

$netadapter | Set-NetIPInterface -DHCP Disabled

 # Configure the IP address and default gateway.

$netadapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress 10.0.1.100 -PrefixLength 24 -Type Unicast -DefaultGateway 10.0.1.1

 # Configure the DNS client server IP addresses.

Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 10.0.1.10

#For your reference, the equaling commands in network shell (netsh.exe) are the following:

netsh interface ip set address name=”Ethernet” static 10.0.1.100 255.255.255.0 10.0.1.1 1

netsh interface ip set dns “Ethernet” static 10.0.1.10
