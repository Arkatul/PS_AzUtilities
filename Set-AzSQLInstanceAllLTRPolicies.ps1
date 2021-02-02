param(
    [Alias('s')][string]
    $SQLManagedInstance,
    [Alias('g')][string]
    $ResourceGroup,
    [Alias('y')][string]
    $YearlyRetention = "PT0S",
    [Alias('m')][string]
    $MonthlyRetention = "P72M",
    [Alias('w')][string]
    $WeeklyRetention = "P13W",
    [Alias('woy')][string]
    $WeekOfYear = 1
)
$list = Get-AzSqlInstanceDatabase -InstanceName $SQLManagedInstance -ResourceGroupName $ResourceGroup;
$dt = New-Object System.Data.Datatable;
[void]$dt.Columns.Add("Database");
[void]$dt.Columns.Add("Weekly Retention");
[void]$dt.Columns.Add("Monthly Retention");
[void]$dt.Columns.Add("Yearly Retention");
[void]$dt.Columns.Add("Week Of Year");

for($i=0;$i -lt $list.count;$i++){
    Write-Progress -Activity "Setting Database LTR Policy  $($i+1) of $($list.count)" -status $list[$i].Name -PercentComplete ($i/$list.Count*100)
    $policy = Get-AzSqlInstanceDatabaseBackupLongTermRetentionPolicy `
    -ResourceGroupName $ResourceGroup `
    -InstanceName $SQLManagedInstance `
    -DatabaseName $list[$i].name;

    $change = $false;
    if($policy.YearlyRetention -ne $YearlyRetention)
    {
        $change = $true;
        $strYearChange = "$($policy.YearlyRetention) -> $YearlyRetention";
    } else
    {
        $strYearChange = "Unchanged : $($policy.YearlyRetention)";
    }
    if($policy.MonthlyRetention -ne $MonthlyRetention)
    {
        $change = $true;
        $strMonthChange = "$($policy.MonthlyRetention) -> $MonthlyRetention";        
    } else
    {
        $strMonthChange = "Unchanged : $($policy.MonthlyRetention)";
    }
    if($policy.WeeklyRetention -ne $WeeklyRetention)
    {
        $change = $true;
        $strWeekChange = "$($policy.WeeklyRetention) -> $WeeklyRetention";            
    } else
    {
        $strWeekChange = "Unchanged : $($policy.WeeklyRetention)";
    }
    if(($policy.WeekOfYear -ne $WeekOfYear) -and ($YearlyRetention -ne "PT0S"))
    {
        $change = $true;
        $strWoYChange = "$($policy.WeekOfYear) -> $WeekOfYear";    
    } else
    {
        $strWoYChange = "Unchanged : $($policy.WeekOfYear)";
    }
    if($change){
        Set-AzSqlInstanceDatabaseBackupLongTermRetentionPolicy `
        -ResourceGroupName $ResourceGroup `
        -InstanceName $SQLManagedInstance `
        -DatabaseName $list[$i].name `
        -YearlyRetention $YearlyRetention `
        -MonthlyRetention $MonthlyRetention `
        -WeeklyRetention $WeeklyRetention `
        -WeekOfYear $WeekOfYear | Out-Null;
        [void]$dt.Rows.Add(
            $policy.DatabaseName, `
            $strWeekChange, `
            $strMonthChange, `
            $strYearChange, `
            $strWoYChange
        )
    }
}
Write-Progress -Activity "Setting Database LTR Policy  $($list.count) of $($list.count)" -status "Done!" -PercentComplete 100

$dt | Sort-Object Database | Format-Table;