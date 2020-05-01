# Install-Splunk
PowerShell script to download and install Splunk Enterprise 

Release Goals:
* Detect the latest version of Splunk ✔
* Download the latest version of Splunk ✔
* Time the download and output the results
* Install with default settings
* No user interaction required
* Automatically create required accounts and return credentials to the user


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
