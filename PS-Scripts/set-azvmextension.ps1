$ResourceId = ''
$(Get-AzMetric -ResourceId $ResourceId -MetricName 'full_backup_size_bytes' -StartTime $((Get-Date).AddDays(-1)) -EndTime $(Get-Date)).Data

Set-AzVMExtension -ResourceGroupName '' -VMName '' -Location 'North Central US' -ExtensionType LinuxDiagnostic -Publisher Microsoft.Azure.Diagnostics -Name LinuxDiagnostic -TypeHandlerVersion 4.0

az vm extension set \
    --resource-group  \
    --vm-name  \
    --name DependencyAgentLinux \
    --publisher Microsoft.Azure.Monitoring.DependencyAgent \
    --version 9.5


Set-AzVMExtension -ResourceGroupName '' -VMName '' -Location 'North Central US' -ExtensionType DependencyAgentLinux -Publisher Microsoft.Azure.Monitoring.DependencyAgent -Name DependencyAgentLinux -TypeHandlerVersion 9.5
