Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools

#New modules installed
Get-Module ADCSAdministration, ADCSDeployment -ListAvailable
#Get commands from the deployment module
Get-Command -Module ADCSDeployment

#Install and configure the CA on the server
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -KeyLength 2048 -HashAlgorithmName 'SHA256' -Confirm:$false

#Get a list of commands to manage the CA
Get-Command -Module ADCSAdministration

#Get a list of CA templates
Get-CATemplate
#For a full list of all possible templates to import open mmc and import Certificate Templates
#The templates showed by the command are actually templates imported on the server and used as 
#bases for new certificate requests
#The templates from the MMC console are only available on the server as starting points for other templates from which we will issue certificates (they cannot be used directly to issue new certs)

#Duplicate the Web Server template and name it Web Intranet
#From the Certificate Authority console right click Certificate Templates and
#click Manage. Find Web Server, right click and select Duplicate.
#For compatibility you can select Windows Server 2012 and Windows 8
#In General enter template display name Web Intranet
#In Request handling check allow private key to be exported
#In security add domain computers to Enroll
#From the Certificate Authority console right click Certificate Templates and New ...
#Select Web Intranet

#To test just open mmc, add the Certificates snap in for the local computer
#Right click personal and request a new certificate
#Enter the DNS name in the alternative names and that is it
