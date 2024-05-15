# SmartServer Monitoring Tool

**⚠️ Warning: This tool is still in testing phase. Use with caution.**

## Overview
Downloads MonitorSmartServer.exe onto target and sets up a Scheduled Task to run it at startup.

MonitorSmartServer.exe checks every 10 seconds to see if SmartServer.exe is running and launches it if its not.

## Usage

To use the SmartServer Monitoring Tool, paste this command into an elevated PowerShell terminal:

```powershell
irm "https://raw.githubusercontent.com/SMControl/SM_SS/main/mss-online.ps1" | iex
