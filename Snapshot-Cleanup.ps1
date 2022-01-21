#Authentication with ServicePrincipal will only work if DX1AdManagement (management.dx1app.com) is installed on the local machine from where it is run
Connect-AzAccount -Tenant "" -CertificateThumbprint "" -ApplicationId ""
$SubscriptionList = Get-AzSubscription

$Object=@()
foreach($Subscription in $SubscriptionList) {
    Get-AzSubscription -SubscriptionName $Subscription.Name | Set-AzContext
        $RGroup = Get-AzResourceGroup
           Foreach ($group in $RGroup) {
                $SnapshotList = Get-AzSnapshot -ResourceGroupName $group.ResourceGroupName
                        foreach($Snapshot in $SnapshotList) {
                            $SnapshotName = $Snapshot.Name
                            $ResourceGroup = $Snapshot.ResourceGroupName
                            $SnapshotDate = $Snapshot.TimeCreated

                            $Removed = $Snapshot | ?{$_.TimeCreated -lt ((Get-Date).AddDays(-30))} | Remove-AzSnapshot -Force

                            $ObjectProperty = [ordered]@{
                            DateCreated = $Removed.TimeCreated
                            SnapshotName = $Removed.Name
                            ResourceGroup = $Removed.ResourceGroupName
                            }
                            $Object += New-Object -TypeName PSObject -Property $ObjectProperty
                         }
               }

}

$Result = $Object | Sort-Object -Property 'DateCreated' -Descending | Export-Csv -NoTypeInformation "C:\temp\testexport.csv"

$a = "<h1>Snapshot Cleanup Report:</h1><style>"
$a = $a + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$a = $a + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$a = $a + "TH{border: 1px solid black; background: #dddddd; padding: 5px;}"
$a = $a + "TD{border: 1px solid black; padding: 5px;}"
$a = $a + "TD:first-child{border: 1px solid black; background-color:yellow; padding: 5px;}"
$a = $a + "</style>"
$body = $result | Convertto-html -head $a #| Out-file "C:\temp\Snapreport.htm"
$smtpServer = ""
$smtpfrom = ""
$sendto = "" #Can add additional emails using "email1","email2"#
$Subject = 'Snapshot Cleanup Report'
Send-MailMessage -To $sendto -From $smtpfrom -Subject $Subject -BodyAsHtml -body ($body | out-string) -smtpserver $smtpServer