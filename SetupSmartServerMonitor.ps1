################################
# Part 1 - Define Variables
################################
$taskName = "SP_SmartServer_Monitor"
$taskActionPath = "C:\SmartServer\SmartServer.exe"
$workingDirectory = "C:\SmartServer"
$monitoringScriptPath = "C:\SmartServer\MonitorSmartServer.ps1"
$currentUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

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
# Part 3 - Create the Monitoring Script
################################
$monitoringScriptContent = '
while ($true) {
  if (-not (Get-Process -Name SmartServer -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath "$taskActionPath" -WorkingDirectory "$workingDirectory" -NoNewWindow
  }
  Start-Sleep -Seconds 30
}
'

try {
  New-Item -Path $monitoringScriptPath -ItemType File -Force
  Set-Content -Path $monitoringScriptPath -Value $monitoringScriptContent
} catch {
  Write-Error "Error creating monitoring script: $($_.Exception.Message)"
  exit
}

################################
# Part 4 - Create Scheduled Task
################################
# Define the action to run the monitoring script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$monitoringScriptPath`""

# Define the trigger to run the task at logon
$trigger = New-ScheduledTaskTrigger -AtLogon

# Define the principal to run with default privileges for the current user
$principal = New-ScheduledTaskPrincipal -UserId $currentUsername -LogonType Interactive

# Define settings to ensure the task runs indefinitely and only one instance runs at a time
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -MultipleInstances IgnoreNew

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings

Write-Output "The scheduled task '$taskName' has been created successfully and will run at logon."
