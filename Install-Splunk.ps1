<# # Elevate to administrator if necessary
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
} #>

# Get the latest version number of Splunk
$VersionNumber = "8.0.3" # Set default version 2020-04-30
$FileName = "splunk-8.0.3-a6754d8441bf-x64-release.msi" # Set default FileName 2020-04-30

try {
  Write-Output "Attempting to determine the latest version of Splunk..."
  $Site = Invoke-WebRequest "https://www.splunk.com/en_us/download/sem.html"

} Catch [NotSupportedException] {
  Write-Output "NotSupportedException - Internet Explorer appears not to be initialised."
  Write-Output "Attempting to work around..."
  try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2
  }
  catch {
    Write-Output 'Unable to set the HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main "DisableFirstRunCustomize" registry value.'
  }
  try {
    Write-Output "Trying again..."
    Write-Output "Attempting to determine the latest version of Splunk"
    $Site = Invoke-WebRequest "https://www.splunk.com/en_us/download/sem.html"
  } catch {
    Write-Output "Unable to determine the latest version, proceeding with version $($VersionNumber)"
  }
}


foreach($Link in $Site.links)
{
    if($Link.innerHTML -match "splunk-(?<version>\d+\.\d+\.\d+)-\w+-x64-release.msi")
    {
        $FileName = $Link.innerHTML
        $VersionNumber = $Matches.version # Set the new version number if successfully obtained
        Write-Output "Found version: $($VersionNumber)"
        break;
    }
}


# Download the latest version of Splunk
# https://download.splunk.com/products/splunk/releases/8.0.3/windows/splunk-8.0.3-a6754d8441bf-x64-release.msi
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