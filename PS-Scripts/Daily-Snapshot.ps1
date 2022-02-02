# Setting up login credentials
$ApplicationId = ''
$passwd = ConvertTo-SecureString '' -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($ApplicationId, $passwd)
$TenantId = ''

# Login using Service Principal
Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId

#Set Subscription Name and defaults
Set-AzContext -SubscriptionName ''
Set-AzDefault

$VMList = Get-AzVM
    foreach ($VM in $VMList) {
        $VMName = $VM.Name
        $ResourceGroup = $VM.ResourceGroupName
        $Location = $VM.Location
            $SnapshotName = $VMName+"-ss-"+(Get-Date -Format "yyyy-MM-dd")
            $SnapshotConfig = New-AzSnapshotConfig -SourceUri $VM.StorageProfile.OsDisk.ManagedDisk.Id -Location $Location -CreateOption Copy
            New-AzSnapshot -Snapshot $SnapshotConfig -SnapshotName $SnapshotName -ResourceGroupName $ResourceGroup   
}
