Set-AWSCredentials -StoreAs ''  -AccessKey '' -SecretKey 'Y' 
Set-AWSCredentials -ProfileName '' 
Initialize-AWSDefaults -ProfileName '' -Region us-west-2

$ZoneIDList = (Get-R53HostedZoneList).Id

$records = Foreach ($ZoneID in $ZoneIDList) {
    (Get-R53ResourceRecordSet -HostedZoneId $ZoneID).ResourceRecordSets |
        Where-Object { $_.Type -in 'TXT', 'SPF' -and $_.ResourceRecords.Value -match 'v=spf' } |
        ForEach-Object {
            foreach ($value in $_.ResourceRecords.Value) {
                [PSCustomObject]@{
                    Name          = $_.Name
                    RecordID      = $ZoneID
                    RecordType    = $_.Type
                    ResourceValue = $value
                }
            }
        }
    }
$records | Where-Object { $_.ResourceValue -match 'v=spf' } | Sort-Object -Property name | Export-CSV -NoTypeInformation "C:\Temp\SPFZones.csv"
