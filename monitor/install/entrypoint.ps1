if(Get-Service *Monitor*) {
    Write-Host "ControlUp monitor service detected. Starting service"
    Get-Service *Monitor* | Start-Service

    Write-Host "ControlUp monitor service started. Waiting for service to stop"
    While((Get-Service "*Monitor*").Status -eq 'Running') { Start-Sleep -Seconds 3600 }
} else {
    Write-Host "Lodctr /R"
    Lodctr /R
    
    Write-Host 'Installing ControlUp Automation Module'
    Install-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
    Install-Module -Name ControlUp.Automation -Force -SkipPublisherCheck -Scope AllUsers | Out-Null
    Write-Host 'ControlUp Automation Module Installed'
    
    Import-Module ControlUp.Automation -Force

    $splat = @{ 
        Token = $env:Token
        InternalDNSName = $ENV:COMPUTERNAME + '.' + $ENV:DomainName
        SiteName = $ENV:SiteName
    }

    Write-Host "Installing ControlUp monitor service"
    
    Install-CUMonitor @splat
    Write-Host "ControlUp monitor service started. Waiting for service to stop"
    While((Get-Service "*Monitor*").Status -eq 'Running') { Start-Sleep -Seconds 3600 }
}