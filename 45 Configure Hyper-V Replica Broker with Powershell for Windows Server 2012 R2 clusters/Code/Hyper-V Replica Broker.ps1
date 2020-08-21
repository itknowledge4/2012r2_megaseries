#Enable the firewall rule for replication on port 80
#Run on all Hyper-V nodes
Enable-NetFirewallRule VIRT-HVRHTTPL-In-TCP-NoScope
#Or
Invoke-Command -Scriptblock {Enable-NetFirewallRule VIRT-HVRHTTPL-In-TCP-NoScope} -Computername 'HVS03A','HVS03B','HVS04A','HVS04B'

#Before you go on make sure your clusters (HVS03 and HVS04) have Create computer objects permission on the OU where the cluster objects will be created

#Configure Broker on first cluster
#Run these commands diretly on a cluster node
$Broker="HVS03-Broker"
Add-ClusterServerRole -Name $Broker -StaticAddress 192.168.10.22
#Can be run remotely from here
Add-ClusterResource -Name "Virtual Machine Replication Broker" -Type "Virtual Machine Replication Broker" -Group $Broker
Add-ClusterResourceDependency "Virtual Machine Replication Broker" $Broker
Start-ClusterGroup $Broker
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos

#Configure broker on second cluster
#Run these commands diretly on a cluster node
$Broker="HVS04-Broker"
Add-ClusterServerRole -Name $Broker -StaticAddress 192.168.10.23
#Can be run remotely from here
Add-ClusterResource -Name "Virtual Machine Replication Broker" -Type "Virtual Machine Replication Broker" -Group $Broker
Add-ClusterResourceDependency "Virtual Machine Replication Broker" $Broker
Start-ClusterGroup $Broker
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos

#Configure both clusters to accept replication from the other clusters broker
New-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HVS04-Broker.testcorp.local' -ReplicaStorageLocation 'C:\ClusterStorage\Volume1\Replicas' -TrustGroup 'ReplicaGroup'
New-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HVS03-Broker.testcorp.local' -ReplicaStorageLocation 'C:\ClusterStorage\Volume1\Replicas' -TrustGroup 'ReplicaGroup'

#Set up a machine for replication
Enable-VMReplication -VMName 'TestVM' -ReplicaServerName 'HVS04-Broker.testcorp.local' -CompressionEnabled $true -ReplicaServerPort 80 -AuthenticationType Kerberos
#Start the initial replication imediately
Start-VMInitialReplication -VMName 'TestVM'
Get-VMReplication -VMName 'TestVM'