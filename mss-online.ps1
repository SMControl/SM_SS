# Download MonitorSmartServer.exe
$downloadUrl = "https://raw.githubusercontent.com/SMControl/SM_SS/main/MonitorSmartServer.exe"
$destinationPath = "C:\SmartServer\MonitorSmartServer.exe"

# Create directory if it doesn't exist
New-Item -ItemType Directory -Path (Split-Path $destinationPath) -Force | Out-Null

# Download the file
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $destinationPath)

################################
# Part 6 - Create Scheduled Task
################################

# Define the trigger for the task to run at system startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define the action for the task to execute the downloaded executable
$action = New-ScheduledTaskAction -Execute "C:\SmartServer\MonitorSmartServer.exe" -WorkingDirectory "C:\SmartServer"

# Define the current user
$currentUser = $env:USERNAME

# Define the settings for the task
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfLoggedOn -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopIfGoingOnBatteries -WakeToRun -RunOnlyIfNetworkAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName "SP_Monitor_SmartServer" -Trigger $trigger -Action $action -User $currentUser -Settings $settings

Write-Host "Task 'SP_Monitor_SmartServer' created and configured for system startup!"
