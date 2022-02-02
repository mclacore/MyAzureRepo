#Authentication with ServicePrincipal will only work if DX1AdManagement (management.dx1app.com) is installed on the local machine from where it is run
Connect-AzAccount -Tenant "" -CertificateThumbprint "" -ApplicationId ""
$SubscriptionList = Get-AzSubscription

$SnapshotCount=0
$Object=@()
foreach($Subscription in $SubscriptionList) {
    Get-AzSubscription -SubscriptionName $Subscription.Name | Set-AzContext
        $SnapshotList = Get-AzSnapshot 
            foreach($Snapshot in $SnapshotList) {
                $SnapshotName = $Snapshot.Name
                $ResourceGroup = $Snapshot.ResourceGroupName
                $SnapshotDate = $Snapshot.TimeCreated

                If ($SnapshotDate -lt ((Get-Date).AddDays(-30))) {
                    $ObjectProperty = [ordered]@{
                    DateCreated = $ResourceGroup
                    SnapshotName = $SnapshotName
                    ResourceGroup = $ResourceGroup
                    }
                    $Object += New-Object -TypeName PSObject -Property $ObjectProperty
                    Remove-AzSnapshot -ResourceGroupName $ResourceGroup -SnapshotName $SnapshotName -Force
                    $SnapshotCount++
                }
        }
