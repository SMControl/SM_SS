# ===========================================================================
# Section 1: Adding Script to Startup Folder (Requires Administrator Privileges)

$scriptDir = (Get-Location).Path
$scriptFile = (Get-ScriptFilename)
$startupFolder = "$env:USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = Join-Path $startupFolder -ChildPath "$scriptFile.lnk"

if (!(Test-Path $shortcutPath)) {
  if (!(Test-Path $startupFolder)) {
    New-Item -ItemType Directory -Path $startupFolder -ErrorAction SilentlyContinue
  }
  New-Item -ItemType SymbolicLink -Path $shortcutPath -Target $scriptPath -Force -ErrorAction SilentlyContinue
}

# ===========================================================================
# Section 2: Monitoring and Restarting SmartServer.exe (Silent)

$smartServerDir = "C:\SmartServer"

function IsSmartServerRunning {
  Get-Process | Where-Object { $_.Name -eq "SmartServer.exe" } | Out-Null
}

while ($true) {
  if (!(IsSmartServerRunning)) {
    Start-Process -FilePath "$smartServerDir\SmartServer.exe" -WorkingDirectory $smartServerDir -Wait -ErrorAction SilentlyContinue
  }
  Start-Sleep -Seconds 30
}
