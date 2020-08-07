#Create test VMs
New-VM -BootDevice CD -MemoryStartupBytes 64MB -Name 'TestVM1' -NewVHDSizeBytes 300MB -NewVHDPath 'C:\VMs\Virtual Machines\TestVM1.vhdx'
New-VM -BootDevice CD -MemoryStartupBytes 64MB -Name 'TestVM2' -NewVHDSizeBytes 300MB -NewVHDPath 'C:\VMs\Virtual Machines\TestVM2.vhdx'
Checkpoint-VM -Name 'TestVM2' -SnapshotName 'Snap 1'


#VM export and import
#Create a folder for exporting VMs
mkdir C:\Export
#Export VM to a path that will be created at export time
Export-VM -Path 'C:\Export' -Name 'TestVM1'
#On the other server create a folder to copy the exported machines
mkdir C:\Import
#Import VM and keep the files exactly where they are
Import-VM -Path 'C:\Import\TestVM1\Virtual Machines\{id}.XML'
#Import VM and copy the files to the default locations (VHDs may be put directly in the configured location)
Import-VM -Path 'C:\Import\TestVM1\Virtual Machines\{id}.XML' -Copy
#Import VM and copy the files to the default locations (specify a location for the disk files)
Import-VM -Path 'C:\Import\TestVM1\Virtual Machines\{id}.XML' -Copy -VhdDestinationPath 'C:\VMs\Virtual Machines'

#Export and import a VM snapshot (new in Windows Server 2012 R2)
#Get the VM snapshot first
$snap=Get-VMSnapshot -VMName TestVM2 -Name 'Snap 1'
Export-VMSnapshot -VMSnapshot $snap -Path C:\Export
#Import the snapshot as a VM (the snapshot name will be the VM name)
Import-VM -Path 'C:\Import\TestVM2\Virtual Machines\{id}.XML' -Copy
