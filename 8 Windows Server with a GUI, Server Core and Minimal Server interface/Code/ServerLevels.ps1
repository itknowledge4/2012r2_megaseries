#Go from Full Server to Server Core
Uninstall-WindowsFeature Server-Gui-Mgmt-Infra -Restart
#Go from Full Server to Minimal Interface
Uninstall-WindowsFeature Server-Gui-Shell -Restart

#Go from Server Core to Full Server
Install-WindowsFeature Server-Gui-Mgmt-Infra,Server-Gui-Shell -Restart
#Go from Server Core to Minimal Interface
Install-WindowsFeature Server-Gui-Mgmt-Infra -Restart

#In case you did not transition from GUI to Core you will not have the needed files in WinSxS so you have to use -Source

#To see the current level
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Server\ServerLevels'