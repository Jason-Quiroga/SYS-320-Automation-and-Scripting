# Storyline: Jason Quiroga's Incident Response Toolkit

function main() {
    cls
    
    # Ask for save location
        $saveLocation = Read-Host -Prompt "Please enter the location that you would like the results of your toolkit to be placed. 
        Please format your results like - 'C:\Users\jason-adm\Desktop' for the file location"
        
        write-host $saveLocation 'path listed. Creating folder at the location...'
        sleep 2

        $destinationLocation = $saveLocation
        $saveLocation += "\ToolkitResults\"
        New-item -Path $saveLocation -ItemType Directory
        
        write-host "Running Toolkit. This may take a moment..."
    # Run functions
        getProcess
        getServices
        getNetSockets
        getAccountInfo
        getNetworkAdapaterConf
        getSecurityEventLogs
        getSystemEventLogs
        getApplicationEventLogs
    # Zip the File
        zipFile
    
    write-host "Toolkit Finished! Files located at $destinationLocation"
}

function getProcess() { # Retrieve all running processes and the path for each process (Submittable 1)
    $fileName = "Processes.csv"
    $newName = "$saveLocation$fileName"
    Get-Process | sort -unique | Select ProcessName, Path | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #1
}

function getServices() { # Retrieve all registered services and the path to the executable controlling the service (using WMI) (Submittable 2)
    $fileName = "Services.csv"
    $newName = "$saveLocation$fileName"
    Get-WmiObject -Class Win32_service | Select Name, State, Path | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #2
}

function getNetSockets() { # Retrieve all TCP network sockets (Submittable 3)
    $fileName = "NetSockets.csv"
    $newName = "$saveLocation$fileName"
    Get-NetTCPConnection | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #3
}

function getAccountInfo() { # Retrieve all user account information (you'll need to use WMI) (Submittable 4)
    $fileName = "AccountInfo.csv"
    $newName = "$saveLocation$fileName"
    Get-WmiObject -Class Win32_Account | sort -Unique | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #4
}

function getNetworkAdapaterConf() { # Retrieve all NetworkAdapterConfiguration information (Submittable 5)
    $fileName = "NetworkAdapterConfiguration.csv"
    $newName = "$saveLocation$fileName"
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #5
}

function getSecurityEventLogs() { # Retrieve the security event logs (cmdlet 1)
    $fileName = "SecurityEventLogs.csv"
    $newName = "$saveLocation$fileName"
    Get-EventLog -LogName Security | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #6

    # This cmdlet is useful because it allows for the viewing of the most recent security logs, which are important when viewing issues related to security.
    # This can include events like user logins, credentials being read, etc.
}

function getSystemEventLogs() { # Retrieve the System event logs (cmdlet 2)
    $fileName = "SystemEventLogs.csv"
    $newName = "$saveLocation$fileName"
    Get-EventLog -LogName System | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #7

    # This cmdlet is useful because it allows for us to view the system event logs that have taken place. This allows us insight into what has been happening on our system
}
function getApplicationEventLogs() { # Retrieve the Application event logs (cmdlet 3)
    $fileName = "ApplicationEventLogs.csv"
    $newName = "$saveLocation$fileName"
    Get-EventLog -LogName Application | export-csv -NoTypeInformation -Path $newName
    addFilehash -pathToFile $newName -nameOfFile $fileName #8

    # This is useful because if there is a malicious program running on our system, we can see what it has been doing all this time.
}
function addFilehash() { # Get the hash for the file
    Param([string] $pathToFile , $nameOfFile)
    $FileHashes = Get-FileHash $pathToFile | Select Hash
    # write-host "The file hash is" $arrFileHashes

    ("$nameOfFile          $FileHashes") >> $saveLocation"fileHashes.txt"
}
function zipFile() { # Zip the file
    Compress-Archive -Path $saveLocation -DestinationPath $destinationLocation"\ToolkitResults.zip"
    $zipFileHash = Get-Filehash $destinationLocation"\ToolkitResults.zip" | select Hash
    "Hash of the Zip File:   $zipFileHash" >> $destinationLocation"\zipFilehash.txt"
}
main