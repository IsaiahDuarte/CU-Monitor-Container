if(Get-Service *Monitor*) {
    Write-Host "ControlUp monitor service detected. Starting service"
    Get-Service *Monitor* | Start-Service

    Write-Host "ControlUp monitor service started. Waiting for service to stop"
    While((Get-Service "*Monitor*").Status -eq 'Running') { Start-Sleep -Seconds 3600 }
} else {
    Write-Host "Updating Host File"
    Add-Content -Path $ENV:WINDIR\System32\drivers\etc\hosts -Value "`n127.0.0.1`t$ENV:MonitorHostName"
    
    Write-Host 'Installing ControlUp Automation Module'
    Install-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
    Install-Module -Name ControlUp.Automation -Force -SkipPublisherCheck -Scope AllUsers | Out-Null
    Write-Host 'ControlUp Automation Module Installed'
    
    Import-Module ControlUp.Automation -Force

    $splat = @{ 
        Token = $env:Token
        InternalDNSName = $ENV:COMPUTERNAME
        SiteName = $ENV:SiteName
    }

    Write-Host "Installing ControlUp monitor service"
    
    Install-CUMonitor @splat
    Write-Host "ControlUp monitor service started. Waiting for service to stop"

    While((Get-Service "*Monitor*").Status -eq 'Running') { Start-Sleep -Seconds 3600 }
}