# SmartServer Monitoring Tool

## WARNING: Still in testing

## Overview

The SmartServer Monitoring Tool is a PowerShell script designed to automate the download and execution of the SmartServer monitoring executable. It also creates a scheduled task to ensure the monitoring tool runs automatically at user logon.

## Features

- Downloads the MonitorSmartServer.exe file from a specified URL.
- Creates a scheduled task to run the monitoring tool at user logon.
- Provides feedback messages for successful execution.

## Usage

To use the SmartServer Monitoring Tool, simply paste the following command into an elevated PowerShell terminal:

```powershell
irm "https://raw.githubusercontent.com/SMControl/SM_SS/main/mss-online.ps1" | iex
