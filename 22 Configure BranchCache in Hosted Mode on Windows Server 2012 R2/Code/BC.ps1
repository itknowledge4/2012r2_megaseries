#Set up the central file server
Install-WindowsFeature BranchCache –IncludeManagementTools
Install-WindowsFeature FS-BranchCache –IncludeManagementTools

####Configure a hosted cache infrastructure
#Create folder and share for the hosted cache part on the central server
mkdir C:\CacheData2
New-SmbShare -CachingMode BranchCache -Name 'CacheData2' -Path C:\CacheData2
#Copy some files in the folder
#Tell the server to calculate hashes for all files
Publish-BCFileContent -Path C:\CacheData2 -StageData
#Export the cache and data so it can be imported on the branch server
mkdir C:\temp
Export-BCCachePackage -Destination C:\temp -ExportDataCache

#On the hosted cache server
Install-WindowsFeature BranchCache –IncludeManagementTools
#Enable the computer as a hosted cache server
Enable-BCHostedServer -RegisterSCP
#Copy the zip file from the content server
#Import the file
Import-BCCachePackage C:\PeerDistPackage.zip

#Make sure the clients are either configured in distributed cache mode with hosted server autodiscover or in hosted mode
#For clients set to autodiscover make sure you restart the service before you try

####General commands
#See most info about BC in one command
Get-BCStatus
#Get configuration of BC client
Get-BCClientConfiguration
#See if current computer is a content server (applies also for distributed clients)
Get-BCContentServerConfiguration
#Get info about the cached data
Get-BCDataCache
#Get info about cached hashes
Get-BCHashCache
#See if a computer is a hosted cache server (clients do not apply)
Get-BCHostedCacheServerConfiguration
#Check if all networking components are in the correct status
Get-BCNetworkConfiguration