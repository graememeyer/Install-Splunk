<# # Elevate to administrator if necessary
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
} #>

# Get the latest version number of Splunk
$VersionNumber = "8.2.6" # Set default version 2021-11-28
$FileName = "splunk-8.2.6-a6fe1ee8894b-x64-release.msi" # Set default FileName 2021-11-28

try {
  Write-Output "Attempting to determine the latest version of Splunk..."
  $Site = Invoke-WebRequest "https://www.splunk.com/en_us/download/splunk-enterprise.html" -UseBasicParsing

} catch {
    Write-Output "Unable to determine the latest version, proceeding with version $($VersionNumber)"
}

[String] $FileName = $Site.Links.ForEach({echo $_ | Select-String -Pattern '(splunk-\d+\.\d+\.\d+(\.\d+)?-\w+-x64-release.msi)' | foreach {$_.Matches} | Select-Object -ExpandProperty Value })

$FileName -Match '(?<VersionNumber>\d+\.\d+\.\d+(\.\d+)?)' | Out-Null
$VersionNumber = $Matches.VersionNumber

# Download the latest version of Splunk
# https://download.splunk.com/products/splunk/releases/8.2.6/windows/splunk-8.2.6-a6fe1ee8894b-x64-release.msi
$BaseDownloadUrl = "https://download.splunk.com/products/splunk/releases/"
$Platform = "windows"
$DownloadUrl = $BaseDownloadUrl + $VersionNumber + "/" + $Platform + "/" + $FileName
$OutPath = "$($env:USERPROFILE)\Desktop\$($FileName)"

Write-Output "Downloading from: $($DownloadUrl)"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest $DownloadUrl -UseBasicParsing -OutFile $OutPath
Write-Output "Wrote file to $($OutPath)"

# Install Splunk Enterprise
Write-Output "Installing Splunk with default settings..."
$DefaultUserName="admin"
$DefaultPassword="password"
$ArgumentList = "/I $($OutPath) AGREETOLICENSE=Yes SPLUNKUSERNAME=$($DefaultUserName) SPLUNKPASSWORD=$($DefaultPassword) INSTALL_SHORTCUT=1 /quiet" 
Start-Process msiexec.exe -Wait -ArgumentList $ArgumentList

Write-Output "Splunk installed with default credentials. UserName:admin Password:password"
Write-Output "Cleaning up the downloads."
Remove-Item $OutPath

Read-Host "Press any key to start Splunk in MS Edge"
Start-Process microsoft-edge:http://localhost:8000
Read-Host "Reminder, your Splunk credentials are: UserName:admin Password:password"
