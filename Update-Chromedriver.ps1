<#
.SYNOPSIS
    Download or update suitable chromedriver.
	
   
.EXAMPLE
    # On Windows...
	# FilePath is the place where you want to store chromedriver
    PS C:\Users\testadmin> powershell -ep Bypass -File Update-Chromedriver.ps1 -FilePath "$HOME\Downloads\"
#>
param([string]$FilePath)

if (! $(Test-Path $FilePath)) {
    Write-Error "The path $FilePath was not found! Halting!"
    exit
}

$chrome_version_pattern = [Regex]::new('\d+\.\d+\.\d+')
$chromedriver_version_pattern = [Regex]::new('\d+\.\d+\.\d+\.\d+')
$temp_results = reg query "HKEY_CURRENT_USER\Software\Google\Chrome\BLBeacon" /v version
$temp_results[2] -match $chrome_version_pattern | Out-Null
$chrome_version = $matches[0]
Write-Output "Chrome version: $chrome_version"
$version_required_url = "http://chromedriver.storage.googleapis.com/LATEST_RELEASE_"+$chrome_version
$chromedriver_exists = Test-Path -Path $FilePath\chromedriver.exe -PathType Leaf
if($chromedriver_exists){
	$temp_results = Invoke-Command { & $FilePath\chromedriver.exe --version}
	$temp_results -match $chromedriver_version_pattern | Out-Null
	$chromedriver_version = $matches[0]
} Else {
	$chromedriver_version = "0"
}
Write-Output "Chromedriver version: $chromedriver_version"
$version_required = (Invoke-WebRequest $version_required_url -UseBasicParsing).Content
Write-Output "Chromedriver version required: $version_required"
if(!$version_required.Equals($chromedriver_version)){
	$chromedriver_url = "https://chromedriver.storage.googleapis.com/"+$version_required+"/chromedriver_win32.zip"
	Write-Output "Downloading chromedriver..."
	Start-BitsTransfer -Source $chromedriver_url -Destination $FilePath\chromedriver_win32.zip -Priority Foreground
	Write-Output "Downlaod complete."
	Write-Output "extracting chromedriver..."
	Expand-Archive -LiteralPath $FilePath\chromedriver_win32.zip -DestinationPath $FilePath -Force
	Write-Output "Extraction complete."
	Write-Output "Cleaning up temporary files..."
	Remove-Item "$FilePath\chromedriver_win32.zip" -Force
	Write-Output "Cleaning done."
	Write-Host "Chromedriver Setup Complete." -BackgroundColor Green
} Else {
	Write-Host "Chromedriver Upto date."
}