#Install the role
Install-WindowsFeature WDS -IncludeAllSubFeature -IncludeManagementTools

#See list of Powershell commands for WDS
Get-Command -Module WDS

#Create a new install image group
New-WdsInstallImageGroup -Name WS
#Import an install image
Import-WdsInstallImage -ImageGroup WS -Path D:\sources\install.wim -ImageName 'Windows Server 2012 R2 SERVERSTANDARDCORE'
Import-WdsInstallImage -ImageGroup WS -Path D:\sources\install.wim -ImageName 'Windows Server 2012 R2 SERVERSTANDARD'
#import a boot image
Import-WdsBootImage -Path D:\sources\boot.wim
