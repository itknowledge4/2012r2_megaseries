#In this example my WSUS server uses a proxy to get to the internet

#Add the WSUS role and install the required roles/features
Install-WindowsFeature -Name UpdateServices -IncludeManagementTools

#Configure WSUS post install
#Create a directory for WSUS
New-Item 'C:\WSUS' -ItemType Directory
& 'C:\Program Files\Update Services\Tools\WsusUtil.exe' postinstall CONTENT_DIR=C:\WSUS

#Get a list of commands for WSUS
Get-Command -Module UpdateServices

#Change different WSUS config items
$wsus = Get-WSUSServer
$wsusConfig = $wsus.GetConfiguration()
Set-WsusServerSynchronization –SyncFromMU
$wsusConfig.UseProxy=$true
$wsusConfig.ProxyName='192.168.1.254'
$wsusConfig.Save()
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.SetEnabledUpdateLanguages(“en”)
$wsusConfig.Save()
$wsusConfig.TargetingMode='Client'
$wsusConfig.Save()
#Get WSUS Subscription and perform initial synchronization to get latest categories
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()
# $subscription.GetSynchronizationStatus() should not be Running to be done
# $subscription.GetSynchronizationProgress() shows you the actual progress in case status is running

$wsusConfig.OobeInitialized = $true
$wsusConfig.Save()

#Get only 2012 R2 updates
Get-WsusProduct | Where-Object {$_.Product.Title -ne "Windows Server 2012 R2"} | Set-WsusProduct -Disable
Get-WsusProduct | Where-Object {$_.Product.Title -eq "Windows Server 2012 R2"} | Set-WsusProduct
#Get only specific classifications
Get-WsusClassification | Where-Object { $_.Classification.Title -notin 'Update Rollups','Security Updates','Critical Updates','Updates','Service Packs'  } | Set-WsusClassification -Disable
Get-WsusClassification | Where-Object { $_.Classification.Title -in 'Update Rollups','Security Updates','Critical Updates','Updates','Service Packs'  } | Set-WsusClassification

#Start a sync
$subscription.StartSynchronization()
$subscription.GetSynchronizationProgress()
$subscription.GetSynchronizationStatus()

#Other things that should be done are configure auto approval rules and sync times

#Create wsus target groups
$wsus.CreateComputerTargetGroup('Servers')
$group = $wsus.GetComputerTargetGroups() | ? {$_.Name -eq "Servers"}
$wsus.CreateComputerTargetGroup("General",$group)

#Approve some updates for the All Computers target group
Get-WsusUpdate | Select-Object -Skip 100 -First 2 | Approve-WsusUpdate -Action Install -TargetGroupName 'All Computers'

#Fix WSUS AppPool stopping constantly
Import-Module WebAdministration
Set-ItemProperty IIS:\AppPools\WsusPool -Name recycling.periodicrestart.privateMemory -Value 2100000
$time=New-TimeSpan -Hours 4
Set-ItemProperty IIS:\AppPools\WsusPool -Name recycling.periodicrestart.time -Value $Time
Restart-WebAppPool -Name WsusPool

#Create a GPO and set client side targeting and intranet wsus server
#Intranet address: http://wsus01.testcorp.local:8530

#Test the updates on one of the servers that the GPO applies to
#Do not forget to issue a gpudate /force before

#Enable reports
#Install .NET 3.5 using the installation iso mounted in the virtual DVD drive (in this case)
Install-WindowsFeature NET-Framework-Core -Source D:\sources\sxs
#Install Microsoft report viewer redistributable 2008
#Get it from: https://www.microsoft.com/en-us/download/confirmation.aspx?id=6576
Start-Process -FilePath 'C:\ReportViewer 2008.exe' -ArgumentList '/q' -Wait
