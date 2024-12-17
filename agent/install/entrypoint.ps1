if(Get-Service *cuagent*) {
    Write-Host "ControlUp monitor service detected. Starting service"
    Get-Service *cuagent* | Start-Service

    Write-Host "ControlUp monitor service started. Waiting for service to stop"
    While((Get-Service "*cuagent*").Status -eq 'Running') { Start-Sleep -Seconds 3600 }
} else {
    Write-Host "Lodctr /R"
    Lodctr /R

    Write-Host 'Installing ControlUp Automation Module'
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Install-Module -Name ControlUp.Automation -Force -SkipPublisherCheck -Scope AllUsers
    Write-Host 'ControlUp Automation Module Installed'
    
    Write-Host 'Installing the CUAgent'
    Import-Module ControlUp.Automation -Force
    $splat = @{ 
        Token = $env:Token
        AgentAuthenticationKey = $env:AgentAuthKey
        AgentRegistrationKey = $env:AgentRegKey
        Site = $ENV:SiteName
    }
    Install-CUAgent @splat
}