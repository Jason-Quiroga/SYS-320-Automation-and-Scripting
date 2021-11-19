# Storyline: Login to a remote SSH server
cls
# New-SSHSession -ComputerName '192.168.4.50' -Credential (Get-Credential jason.quiroga@cyber.local)

<#
while ($True) {

    # Add a prompt to run commands
    $the_cmd = read-host -Prompt "Please enter a command to run on the Remote SSH"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $the_cmd).Output
}
#>

# Set-SCPFile -ComputerName '192.168.4.50' -Credential (Get-Credential jason.quiroga@cyber.local) `
# -RemotePath '' -LocalFile 'C:\Users\jason-adm\Desktop\hi.txt'

#Set-SCPItem -ComputerName '192.168.4.50' -Credential (Get-Credential jason.quiroga@cyber.local) `
#-Destination '/home/jason.quiroga@cyber.local' -Path 'C:\Users\jason-adm\Desktop\hi.txt'