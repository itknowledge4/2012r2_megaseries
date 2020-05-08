#Get the device that implements the GenerationID
Get-WmiObject win32_pnpentity | where {$_.caption -eq 'Microsoft Hyper-V Generation Counter'}

#Get the current value of this ID from AD
Get-ADObject -Filter {samaccountname -like "DC01*"} -Properties * | Select-Object -ExpandProperty msDS-GenerationId
#The GenerationID is stored locally on each Domain Conteoller's database and it is not replicated
#So if you are on DC01 this should not return anything
Get-ADObject -Filter {samaccountname -like "DC02*"} -Properties * | Select-Object -ExpandProperty msDS-GenerationId