# Install-Splunk
PowerShell script to download and install Splunk Enterprise 

Try this to install directly from PowerShell:

```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/graememeyer/Install-Splunk/master/Install-Splunk.ps1'))
```


Release Goals:
* Detect the latest version of Splunk ✔
* Download the latest version of Splunk ✔
* Time the download and output the results
* Install with default settings ✔
* No user interaction required ✔
* Automatically create required accounts and return credentials to the user ✔

To-Do:
* Increase the upload limit for the web interface
* Set an all-user powershell alias for Splunk
* Detect and automatically install Splunk Enterprise Security 
  * Ask the user if they want to install it / provide a path to an ES binary

Stretch Goals:
* Graceful failure
* Download to temporary folder and clean up afterwards
* Elevate to admin if required
* Download progress indicator
* Install progress indicator
* Multiple download strategies, defaulting to the fastest
* Configurable options
* Automatically open Splunk console in the default browser
* Automatically update the git repository with the latest-known version numbers
