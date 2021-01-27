param (
    [Alias('s')]
    $SourceKeyVaultName,
    [Alias('d')]
    $DestinationKeyVaultName,
    [Alias('n')]
    $SecretName,
    $DestinationSecretName
    )
$SourceKeyVault = Get-AzKeyVault -VaultName $SourceKeyVaultName
Write-Host $SourceKeyVault