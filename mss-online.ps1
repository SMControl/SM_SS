# Download MonitorSmartServer.exe
$downloadUrl = "https://raw.githubusercontent.com/SMControl/SM_SS/main/MonitorSmartServer.exe"
$destinationPath = "C:\SmartServer\MonitorSmartServer.exe"

# Create directory if it doesn't exist
New-Item -ItemType Directory -Path (Split-Path $destinationPath) -Force | Out-Null

# Download the file
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $destinationPath)

# Create Scheduled Task (remaining sections unchanged)
$trigger = New-ScheduledTaskTrigger -AtStartup
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\SmartServer\MonitorSmartServer.exe"
$settings = New-ScheduledTaskSettingsSet -RunAsSystem

Register-ScheduledTask -TaskName "SP_Monitor_SmartServer" -Trigger $trigger -Action $action -Settings $settings

# Run the Task (Optional - not recommended)
Start-ScheduledTask -TaskName "SP_Monitor_SmartServer"

Write-Host "Task 'SP_Monitor_SmartServer' created and configured for system startup!"
