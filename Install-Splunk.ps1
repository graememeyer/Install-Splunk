<# # Elevate to administrator if necessary
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
} #>

# Get the latest version number of Splunk
$VersionNumber = "8.1.0.1" # Set default version 2020-11-05
$FileName = "splunk-8.1.0.1-24fd52428b5a-x64-release.msi" # Set default FileName 2020-11-05

try {
  Write-Output "Attempting to determine the latest version of Splunk..."
  $Site = Invoke-WebRequest "https://www.splunk.com/en_us/download/sem.html%3Fac%3DAdwords_Loglogic" -UseBasicParsing

} catch {
    Write-Output "Unable to determine the latest version, proceeding with version $($VersionNumber)"
}

foreach($Link in $Site.links)
{
    if($Link.outerHTML -match "(?<fullmatch>https://download.splunk.com/products/splunk/releases/(?<version>\d+(\.\d+)+)/windows/(?<filename>splunk-\d+(\.\d+)+-\w+-x64-release.msi))")
    {
        # $DownloadUrl = $Matches.fullmatch 
        $FileName = $Matches.filename
        $VersionNumber = $Matches.version # Set the new version number if successfully obtained
        Write-Output "Found version: $($VersionNumber)"
        break;
    }
}

# Download the latest version of Splunk
# https://download.splunk.com/products/splunk/releases/8.1.0.1/windows/splunk-8.1.0.1-24fd52428b5a-x64-release.msi
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
