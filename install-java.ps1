$AdoptOpenJDKUrl = "https://api.adoptopenjdk.net/v3/binary/latest/8/ga/windows/x64/jdk/openj9/normal/adoptopenjdk?project=jdk"
$JdkZip = "OpenJDK8U-jdk_x64_windows_openj9.zip"
$installation_path = "$ENV:UserProfile\java-env"
New-Item $installation_path -ItemType "directory" -Force | Out-Null
Write-Output "Created installation directory, installation path: $installation_path"

# Downloading Section
Write-Output "Downloading AdoptOpenJDK8 latest stable. Please Wait..."
(New-Object System.Net.WebClient).DownloadFile($AdoptOpenJDKUrl,"$installation_path\$JdkZip")
Write-Output "AdoptOpenJDK8 Latest Stable Download Complete"

# Extraction Section
Expand-Archive -LiteralPath "$installation_path\$JdkZip" -DestinationPath "$installation_path" -Force

# Configrations
$java_home = (Get-ChildItem -LiteralPath $installation_path -Directory).FullName | Where {$_ -match "jdk"}
[System.Environment]::SetEnvironmentVariable('JAVA_HOME',$java_home,[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('JAVA_HOME',$java_home,[System.EnvironmentVariableTarget]::Process)
$path = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User) + "$java_home\bin;"
[System.Environment]::SetEnvironmentVariable('PATH',$path,[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('PATH',$path,[System.EnvironmentVariableTarget]::Process)

# Clean up Section
Write-Output "Cleaning up temporary files..."
Remove-Item "$installation_path\*.zip" -Force
Write-Output "Cleaning done."

Write-Host "Congratulations Adpot OpenJDK Installation Completed." -BackgroundColor Green