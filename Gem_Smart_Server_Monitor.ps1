# Set the directory where SmartServer.exe resides
$smartServerDir = "C:\SmartServer"

# Create a function to check if SmartServer.exe is running
function IsSmartServerRunning {
  Get-Process | Where-Object { $_.Name -eq "SmartServer.exe" } | Out-Null
}

# Continuously check and restart SmartServer.exe every 30 seconds
while ($true) {
  # Check if SmartServer is running
  if (!(IsSmartServerRunning)) {
    Write-Host "SmartServer.exe is not running. Restarting..."
    Start-Process -FilePath "$smartServerDir\SmartServer.exe" -WorkingDirectory $smartServerDir -Wait
  }
  Start-Sleep -Seconds 30 # Wait 30 seconds before checking again
}
