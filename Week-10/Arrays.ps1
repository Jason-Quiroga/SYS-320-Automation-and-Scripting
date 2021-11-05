# Storyline: View the event logs, check to be sure that the user specified a valid log, print results

function select_log() {
    cls

    # List all event-logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host

    # Initialize the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {

        # Add each log to the array
        # We want these are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}

        $arrLog += $tempLog
    }

    # Test if the array is populated
    # $arrLog

    # Prompt the user for the log that they want to view, or quit the program
    $readLog = Read-Host -Prompt "Please enter a log from the list above, or 'q' to quit the program"

    # Check if the user wants to quit
    if ($readLog -imatch "^q$") {
        
        # Stop executing the program and close the script
        write-host "Quitting!"
        break
    }
    # If there is no quit selected, then run log_check
    log_check -logToSearch $readLog

} # Ends the select_log()

function log_check() {

    # String the user types in within the select_log function.
    Param([string] $logToSearch)

    # Format the user input
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the Array for the exact hashtable string
    if ($arrLog -match $theLog) {
        
        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries..."
        sleep 2

        # Call the function to view the log.
        view_log -logToSearch $logToSearch

    } else {
    Write-Host -BackgroundColor Red -ForegroundColor White "The Log Type you entered was incorrect. Please try again."
    sleep 2
    select_log
    }
} # Ends the log_check()

function view_log() {

    cls

    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "11/4/2021"

    # Pause the screen and wait until the user is ready to proceed.
    Read-Host -Prompt "Press enter when you are done"

    # Return to the start of the program
    select_log

} # Ends the view_log()

select_log