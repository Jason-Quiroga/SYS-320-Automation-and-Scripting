# Export list of running processes and running services on my system into separate files

# Services
Get-Service | Where {$_.Status -eq "Running"} |export-csv -Path C:\Users\jason-adm\Desktop\services.csv -NoTypeInformation

#Processes
Get-Process | Select ProcessName, Path, ID | export-csv -Path C:\Users\jason-adm\Desktop\processes.csv -NoTypeInformation