# Storyline: Review the Security Event Log

# List all the available Windows Event Logs
Get-EventLog -list

# Directory to Save Files
$myDir = "C:\Users\jason-adm\Desktop"

# Create a prompt to allow the user to select the Log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"


# Task: Create a prompt that allows the user to specify a keyword or phrase to search on.
# Find a string from your event logs to search on

$readPhrase = Read-host -Prompt "Please Specify a Keyword or Phrase to search the logs for"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readPhrase*" } | export-csv -NoTypeInformation ` -Path "$myDir\securityLogs.csv"
