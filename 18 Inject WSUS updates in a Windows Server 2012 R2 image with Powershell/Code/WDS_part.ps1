Get-WdsInstallImage | Select-Object Name
Remove-WdsInstallImage -ImageName 'Windows Server 2012 R2 SERVERSTANDARD'
Remove-WdsInstallImage -ImageName 'Windows Server 2012 R2 SERVERSTANDARDCORE'

#After the updates have been injected just import the image in WDS
Import-WdsInstallImage -ImageGroup WS -Path C:\install.wim -ImageName 'Windows Server 2012 R2 SERVERSTANDARDCORE'
Import-WdsInstallImage -ImageGroup WS -Path C:\install.wim -ImageName 'Windows Server 2012 R2 SERVERSTANDARD'