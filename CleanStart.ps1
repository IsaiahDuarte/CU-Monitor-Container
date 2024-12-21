& docker compose down --rmi all --volumes --remove-orphans
Remove-Item C:\ControlUp\MonitorProfile -Recurse -Force
Remove-Item C:\ControlUp\MonitorEventLogs -Recurse -Force
Remove-Item C:\ControlUp\AgentEventLogs -Recurse -Force
New-Item C:\ControlUp\AgentEventLogs -ItemType Directory
New-Item C:\ControlUp\MonitorEventLogs -ItemType Directory
New-Item C:\ControlUp\MonitorProfile -ItemType Directory
& docker compose build
& docker compose up -d
& docker exec -it cumonitor powershell
