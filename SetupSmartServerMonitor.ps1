################################
# Part 1 - Define Task Details (Hardcoded)
################################
$taskName = "SP_SmartServer_Monitor"
$taskActionPath = "C:\SmartServer\SmartServer.exe"
$workingDirectory = "C:\SmartServer"
$monitoringScriptContent = 'while ($true) { if (-not (Get-Process -Name SmartServer -ErrorAction SilentlyContinue)) { Start-Process -FilePath "C:\SmartServer\SmartServer.exe" -WorkingDirectory "C:\SmartServer" -NoNewWindow } Start-Sleep -Seconds 30 }'

################################
# Part 2 - Check if Task Already Exists and is Running
################################
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
  Write-Output "The scheduled task '$taskName' already exists. Checking if it's running..."
  
  # Check if the scheduled task is already running
  $taskInstance = Get-ScheduledTask -TaskName $taskName
  if ($taskInstance.State -eq 'Running') {
    Write-Output "The scheduled task '$taskName' is already running. Exiting script."
    exit
  }
}

################################
# Part 4 - Create Scheduled Task (Highest Privileges)
################################
# Define the action to run the monitoring script (hardcoded path)
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -File C:\SmartServer\MonitorSmartServer.ps1"

# Define the trigger to run the task at logon
$trigger = New-ScheduledTaskTrigger -AtLogon

# Define the principal to run with highest privileges (requires admin)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Define settings to ensure the task runs indefinitely and only one instance runs at a time
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -MultipleInstances IgnoreNew

# Register the scheduled task (requires admin)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings

# Start the scheduled task (optional, requires admin)
Start-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

Write-Output "The scheduled task '$taskName' has been created successfully and will run at logon with highest privileges. (Task also started, if successful)"
