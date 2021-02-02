param(
    [Alias('s')][string]
    $SQLManagedInstance,
    [Alias('g')][string]
    $ResourceGroup
)
$list = Get-AzSqlInstanceDatabase -InstanceName $SQLManagedInstance -ResourceGroupName $ResourceGroup;
$dt = New-Object System.Data.Datatable;
[void]$dt.Columns.Add("Database");
[void]$dt.Columns.Add("Weekly Retention");
[void]$dt.Columns.Add("Monthly Retention");
[void]$dt.Columns.Add("Yearly Retention");
[void]$dt.Columns.Add("Week Of Year");
for($i=0;$i -lt $list.count;$i++){
    Write-Progress -Activity "Gathering Database LTR Information  $($i+1) of $($list.count)" -status $list[$i].Name -PercentComplete ($i/$list.Count*100)
    $policy = Get-AzSqlInstanceDatabaseBackupLongTermRetentionPolicy -ResourceGroupName $ResourceGroup -InstanceName $SQLManagedInstance -DatabaseName $list[$i].name;
    [void]$dt.Rows.Add($policy.DatabaseName,$policy.WeeklyRetention,$policy.MonthlyRetention,$policy.YearlyRetention,$policy.WeekOfYear);
}
Write-Progress -Activity "Gathering Database LTR Information $($list.count) of $($list.count)" -status "Done!" -PercentComplete 100

$dt | Sort-Object Database | Format-Table;