param(
    [Alias('s')][string]
    $SQLManagedInstance,
    [Alias('g')][string]
    $ResourceGroup
)
$list = Get-AzSqlInstanceDatabase -InstanceName $SQLManagedInstance -ResourceGroupName $ResourceGroup
for($i=0;$i -lt $list.count;$i++){
    Get-AzSqlInstanceDatabaseBackupLongTermRetentionPolicy -ResourceGroupName $ResourceGroup -InstanceName $SQLManagedInstance -DatabaseName $list[$i].name;
}