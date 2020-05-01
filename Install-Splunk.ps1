# TODO elevate to administrator if necessary

# Get the latest version number of Splunk
$VersionNuumber = "8.0.3" # Set default version 2020-04-30
$FileName = splunk-8.0.3-a6754d8441bf-x64-release.msi # Set default FileName 2020-04-30
$Site = Invoke-WebRequest https://www.splunk.com/en_us/download/sem.html
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
 
Write-Host "$($DownloadUrl)"

Invoke-WebRequest $DownloadUrl | Out-File $env:USERPROFILE\Desktop\$FileName