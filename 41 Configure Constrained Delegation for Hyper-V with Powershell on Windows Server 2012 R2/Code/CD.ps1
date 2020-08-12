#Create test VM
New-VM -BootDevice CD -MemoryStartupBytes 64MB -Name 'TestVM1' -NewVHDSizeBytes 300MB -NewVHDPath 'C:\VMs\Virtual Machines\TestVM1.vhdx'

$computer=Get-ADComputer hv01
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('cifs/HVS01.testcorp.local')}
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('Microsoft Virtual System Migration Service/HVS01')}
Set-ADAccountControl -Identity $Computer -TrustedForDelegation $true

$computer=Get-ADComputer hvs01
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('cifs/HV01.testcorp.local')}
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('Microsoft Virtual System Migration Service/HV01')}
Set-ADAccountControl -Identity $Computer -TrustedForDelegation $true