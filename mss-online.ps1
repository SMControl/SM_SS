# Download MonitorSmartServer.exe
$downloadUrl = "https://raw.githubusercontent.com/SMControl/SM_SS/main/MonitorSmartServer.exe"
$destinationPath = "C:\SmartServer\MonitorSmartServer.exe"

try {
  New-Item -ItemType Directory -Path (Split-Path $destinationPath) -Force | Out-Null  # Create directory if it doesn't exist
  (New-Object System.Net.WebClient).DownloadFile($downloadUrl, $destinationPath)
  Write-Host "Download successful!"
}
catch {
  Write-Error "Download failed: $($_.Exception.Message)"
  exit 1
}

# Create Scheduled Task
$trigger = New-ScheduledTaskTrigger -Logon -AtLogon
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\SmartServer\MonitorSmartServer.exe"
$settings = New-ScheduledTaskSettingsSet -RunAsSystem

Register-ScheduledTask -TaskName "SP_Monitor_SmartServer" -Trigger $trigger -Action $action -Settings $settings

# Run the Task
Start-ScheduledTask -TaskName "SP_Monitor_SmartServer"

Write-Host "Task 'SP_Monitor_SmartServer' created and started successfully!"
