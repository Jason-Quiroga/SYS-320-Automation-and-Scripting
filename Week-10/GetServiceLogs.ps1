# Storyline: Program that lists all registered services (where stopped or running)
# Author: Jason Quiroga

function menu() {

    cls

    # Prompt that allows the user to select if they want to view all services, running, or stopped.
    $userChoice = Read-Host -prompt "Please choose if you want to view all services (all), just running services (running), just stopped services(stopped), or if you would like to quit (q)"

    if ($userChoice -imatch "^q$") {
        
        # Stop executing the program and close the script
        write-host "Quitting!"
        break
    }
    # Initialize the array
    $arrServices = @('all','stopped','running')

    #run the input_check function
    input_check -serviceTypeToDisplay $userChoice
}

function input_check() {
    
    Param([string] $serviceTypeToDisplay)

    # Check to make sure that the user specified only all, running, or stopped
    if ($arrServices -imatch $serviceTypeToDisplay) {
        
        write-host -BackgroundColor Green -ForegroundColor White "Choice is correct."
        sleep 2

        # Call the function to view the log.
        list_services -serviceTypeToDisplay $serviceTypeToDisplay

    } else {
    Write-Host -BackgroundColor Red -ForegroundColor White "Choice is incorrect. Please select 'all', 'running', 'stopped', or 'q' to quit."
    sleep 2
    menu
    }
}

function list_services() {

    if ($serviceTypeToDisplay -imatch $arrServices[0]) {             # Choice = "all"
        gsv
    } elseif ($serviceTypeToDisplay -imatch $arrServices[1]) {       # Choice = "stopped"
        gsv | where {$_.Status -eq "Stopped"}
    } elseif ($serviceTypeToDisplay -imatch $arrServices[2]) {       # Choice = "running"
        gsv | where {$_.Status -eq "Running"}
    }

    # Pause the screen and wait until the user is ready to proceed.
    Read-Host -Prompt "Press enter when you are done"

    # Return to the start of the program
    menu
}
menu