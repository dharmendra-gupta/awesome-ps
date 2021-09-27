Import-Module BitsTransfer
$mavenUrl = "https://apache.claz.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.zip"
Start-BitsTransfer -Source $mavenUrl -Destination "$ENV:UserProfile\apache-maven.zip"
Expand-Archive -LiteralPath "$ENV:UserProfile\apache-maven.zip" -DestinationPath "$ENV:UserProfile" -Force
$maven_home = (Get-ChildItem -LiteralPath "$ENV:UserProfile" -Directory).FullName | Where {$_ -match "maven"}
$path = [System.Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User) + "$maven_home\bin;"
[System.Environment]::SetEnvironmentVariable('PATH',$path,[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('PATH',$path,[System.EnvironmentVariableTarget]::Process)
Remove-Item "$ENV:UserProfile\apache-maven.zip" -Force
