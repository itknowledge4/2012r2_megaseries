#Enable teaming on the host for the VM net adapters
Get-VMNetworkAdapter -VMName 'HV01' |Set-VMNetworkAdapter -AllowTeaming On

#Get a list of all network adapters
Get-NetAdapter

#Get a list of all teams
Get-NetLbfoTeam
#Create a new team with the NIC name Team1 and the team name PublicTeam
New-NetLbfoTeam -Name 'PublicTeam' -TeamNicName 'Team1' -TeamingMode SwitchIndependent -TeamMembers 'Ethernet','Ethernet 3' -Confirm:$false
#Set the second NIC as a standby
Set-NetLbfoTeamMember -Name 'Ethernet 3' -Team 'PublicTeam' -AdministrativeMode Standby
#Get data about the NIC assigned to the team
Get-NetLbfoTeamNic
#Get data about members of a team (in this case we do not specify the team since we have only one)
Get-NetLbfoTeamMember
#Set a NIC from a team to active (or standby)
Set-NetLbfoTeamMember -Name 'Ethernet 3' -AdministrativeMode Active
#Remove a NIC from a team
Remove-NetLbfoTeamMember -Name 'Ethernet 3' -Team PublicTeam -Confirm:$false
#Add a NIC to a team
Add-NetLbfoTeamMember -Name 'Ethernet 3' -Team 'PublicTeam' -AdministrativeMode Standby -Confirm:$false
#Remove a team
Remove-NetLbfoTeam -Name PublicTeam -Confirm:$false