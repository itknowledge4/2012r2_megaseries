#Create test VM
New-VM -BootDevice CD -MemoryStartupBytes 64MB -Name 'TestVM1' -NewVHDSizeBytes 300MB -NewVHDPath 'C:\VMs\Virtual Machines\TestVM1.vhdx'

#Run the LM settings commands on the hosts that will be part of the migration scenario
Set-VMHost -VirtualMachineMigrationAuthenticationType Kerberos -UseAnyNetworkForMigration $true
#To set a different enhancement for the live migration use
Set-VMHost -VirtualMachineMigrationPerformanceOption SMB
Set-VMHost -VirtualMachineMigrationPerformanceOption TCPIP
Set-VMHost -VirtualMachineMigrationPerformanceOption Compression

#Enable vm live migrations
Enable-VMMigration

#Add a subnet in the list of migration networks. Has effect if -UseAnyNetworkForMigration is $false
Add-VMMigrationNetwork -Subnet '192.168.1.0/24'

#Live migrate a VM to another host with all its VHD files and delete it from the source while keeping the destination default storage locations (shared nothing lm)
Move-VM -Name 'TestVM1' -DestinationHost 'HVS01' -IncludeStorage