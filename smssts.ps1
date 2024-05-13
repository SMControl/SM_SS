################################
# Part 1 - Define Variables
################################
$taskName = "SP_SmartServer"
$taskActionPath = "C:\SmartServer\SmartServer.exe"
$workingDirectory = "C:\SmartServer"

################################
# Part 2 - Check if Task Already Exists
################################
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Write-Output "The scheduled task '$taskName' already exists. Exiting script."
    exit
}

################################
# Part 3 - Create Scheduled Task
################################
# Define the action to run the executable with the specified working directory
$action = New-ScheduledTaskAction -Execute $taskActionPath -WorkingDirectory $workingDirectory

# Define the trigger to run the task at startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define the principal to run with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Define settings to ensure the task runs indefinitely and restarts if it fails
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RestartCount 9999 -RestartInterval (
