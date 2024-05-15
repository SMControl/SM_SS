#########################################
# Section 1: Download
#########################################

# Download MonitorSmartServer.exe
$downloadUrl = "https://raw.githubusercontent.com/SMControl/SM_SS/main/MonitorSmartServer.exe"
$destinationPath = "C:\SmartServer\MonitorSmartServer.exe"

# Download the file
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $destinationPath)

#########################################
# Section 2: Task Creation
#########################################

# Create Scheduled Task
$trigger = New-ScheduledTaskTrigger -AtLogon
$action = New-ScheduledTaskAction -Execute "C:\SmartServer\MonitorSmartServer.exe" -WorkingDirectory "C:\SmartServer"
Register-ScheduledTask -TaskName "SP_Monitor_SmartServer" -Trigger $trigger -Action $action

Write-Host "Task 'SP_Monitor_SmartServer' created and configured to run at user logon!"
