# Define service properties
$serviceName = "SM_MonitorSmartServer"
$displayName = "Monitor Smart Server Service"
$description = "Runs MonitorSmartServer.exe continuously"
$startupType = "Automatic"  # Change to "Manual" if you don't want auto-start
$executablePath = "$downloadPath\MonitorSmartServer.exe"

# Create the service
New-Service -Name $serviceName -DisplayName $displayName -Description $description -StartupType $startupType -BinaryPathName $executablePath

# Check service creation status
if (Get-Service $serviceName) {
    Write-Host "Service '$serviceName' created successfully!"
    # Optionally, start the service automatically
    # Start-Service $serviceName
} else {
    Write-Error "Failed to create service '$serviceName'"
}
