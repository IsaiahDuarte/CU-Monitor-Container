# escape=`
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Args used by from statements must be defined here:
    ARG InstallerVersion=nanoserver
    ARG dockerHost=mcr.microsoft.com
    ARG InstallerRepo=mcr.microsoft.com/powershell
    ARG NanoServerRepo=windows/servercore
    ARG tag=ltsc2022
    
    FROM mcr.microsoft.com/${NanoServerRepo}:${tag}
    
    # Switch to Administrator
    USER ContainerAdministrator
        
    # Changing to pwsh shell
    SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

    # Copy the install folder to the container
    COPY install install
    WORKDIR c:/install
    
    RUN powershell `
            -NoLogo `
            -NoProfile `
            -Command " `
            Write-Host 'Installing ControlUp Automation Module' ; `
            Install-PackageProvider -Name NuGet -Force -Confirm:$false ; `
            Install-Module -Name ControlUp.Automation -Force -SkipPublisherCheck -Scope AllUsers ; `
            Write-Host 'ControlUp Automation Module Installed' ; `
            "
    
    # ARGs for the entrypoint script
    ARG Token
    ARG InternalDNSName
    ARG PublicDNSName
    
    ENV Token=$Token
    ENV InternalDNSName=$InternalDNSName
    ENV PublicDNSName=$PublicDNSName    
    
    ENTRYPOINT powershell -File c:/install/entrypoint.ps1 -CUAPIToken $Env:Token -InternalDNSName $Env:InternalDNSName -PublicDNSName $Env:PublicDNSName
    #FROM mcr.microsoft.com/dotnet/framework/runtime:4.8 AS base 

