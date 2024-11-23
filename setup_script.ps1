# Download Console
Invoke-WebRequest -Uri "https://downloads.controlup.com/console/9.0.5.426/ControlUp.zip" -OutFile "C:\setup_files\ControlUp.zip"
Expand-Archive -Path "C:\setup_files\ControlUp.zip" -DestinationPath "C:\setup_files"