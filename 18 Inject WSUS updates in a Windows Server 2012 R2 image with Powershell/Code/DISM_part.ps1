#Copy the install.wim to a local folder from the DVD
cd C:\
Copy-Item D:\sources\install.wim .\
Set-ItemProperty C:\install.wim -Name IsReadOnly -Value $false

mkdir C:\mount
$MountDir='C:\mount'

Get-WindowsImage -ImagePath 'C:\install.wim'
Mount-WindowsImage -Path $mountdir -ImagePath C:\install.wim -Index 1
foreach($upd in $UpdateFiles){ Add-WindowsPackage -PackagePath $upd -Path $mountdir }
Dismount-WindowsImage -Path $mountdir -Save


