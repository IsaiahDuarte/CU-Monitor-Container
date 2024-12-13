param(
    [string]$CUAPIToken = "",
    [string]$PublicDNSName = "",
    [string]$InternalDNSName = ""
)

if(Get-Service *Monitor*) {
    Write-Host "ControlUp monitor service detected. Starting service"
    Get-Service *Monitor* | Start-Service
    # Keep the container running
    While($true) { Start-Sleep -Seconds 3600 }
}

Write-Host "Token: $CUAPIToken"
Write-Host "PublicDNSName: $PublicDNSName"
Write-Host "InternalDNSName: $InternalDNSName"

# Import the Module
Import-Module ControlUp.Automation -Force

Set-CUAPIToken $CUAPIToken
Install-CUMonitor `
    -Token $CUAPIToken `
    -InternalDNSName "docker-monitor-01.local" `

# Start the ControlUp Monitor service
Write-Host "Starting ControlUp Monitor service..."
#Start-Service -Name "ControlUp Monitor"

# Keep the container running
Write-Host "ControlUp Monitor service is running. Keeping the container alive..."
