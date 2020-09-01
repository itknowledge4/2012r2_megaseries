#Create the KDS root key
#If in a production environment leave it with the default wait time so it can replicate to all DCs
#For a test environment run:
Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
#For a production environment run:
Add-KdsRootKey

#Create a group to put servers that will be allowed to use the gMSA in it
New-ADGroup -Name gMSAGroup -GroupScope DomainLocal
#Add a test server to the group
Add-ADGroupMember -Identity gMSAGroup -Members HV01$
#You should restart the computer after adding it to the group

#Create the gMSA
New-ADServiceAccount TestgMSA -DNSHostName TestgMSA.testcorp.local -PrincipalsAllowedToRetrieveManagedPassword gMSAGroup

#Run on the server that will use the gMSA
#The host must have the AD Powershell module installed
Install-WindowsFeature RSAT-AD-PowerShell
#Install the account - Run directly on the host
Install-ADServiceAccount -Identity TestgMSA
#Test that the account can be used - Run directly on the host
Test-ADServiceAccount TestgMSA
#Create a cheduled task that will use the gMSA
$action = New-ScheduledTaskAction "c:\test\script.bat"
$trigger = New-ScheduledTaskTrigger -Once -At 20:00
$user = New-ScheduledTaskPrincipal -UserID testcorp\TestgMSA$ -LogonType Password
Register-ScheduledTask TestRun -Action $action -Trigger $trigger -Principal $user

#Remove a gMSA from the local computer
Uninstall-ADServiceAccount -Identity TestgMSA

