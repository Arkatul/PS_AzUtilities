param
(
    [alias('si')][string]
    $SourceSQLManagedInstance,
    [alias('sg')][string]
    $SourceResourceGroup,
    [alias('di')][string]
    $DestinationSQLManagedInstance,
    [alias('dg')][string]
    $DestinationResourceGroup,
    [string]
    $RestoredDatabaseSuffix = ""
)
$geobackups = Get-AzSqlInstanceDatabaseGeoBackup -ResourceGroupName $ResourceGroup -InstanceName $ManagedInstance
$geobackups | ForEach-Object -Process {
    $_ | Add-Member DestinationName -NotePropertyValue "$($_.Name)$RestoredDatabaseSuffix"
}
$geobackups | Sort-Object Name | Format-Table -Property Name,DestinationName
$answer = Read-Host "Restoring these Databases to $DestinationSQLManagedInstance, are you sure? [Y]es, [N]o"
while(!$answer -OR ($answer -ine "y" -AND $answer -ine "yes" -AND $answer -ine "n" -AND $answer -ine "no"))
{
    $answer = Read-Host "Invalid response, are you sure? [Y]es, [N]o"
}
if ($answer -ieq "no" -OR $answer -ieq "n"){ exit; }
$i = 1;
$geobackups | ForEach-Object -Process {
    Write-Progress -Activity "Restoring Database  $($i) of $($geobackups.count)" -status $_.Name -PercentComplete ($i/$geobackups.count*100)
    $_ | Restore-AzSqlInstanceDatabase `
        -FromGeoBackup `
        -TargetInstanceDatabaseName "$($_.Name)$RestoredDatabaseSuffix" `
        -TargetInstanceName $DestinationManagedInstance `
        -TargetResourceGroupName $DestinationResourceGroup `
        
    $i++;
}
Write-Progress -Activity "Restoring Database  $($geobackups.count) of $($geobackups.count)" -status "Done!" -PercentComplete 100