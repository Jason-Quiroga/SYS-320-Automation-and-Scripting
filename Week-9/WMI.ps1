# Use the Get-WMI cmdlet

# Task: Grab the network adapter information using the WMI class
# Get the IP Address, Default Gateway, and DNS servers
# Bonus: Get the DHCP server

Get-WmiObject -class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DHCPServer, DNSServerSearchOrder