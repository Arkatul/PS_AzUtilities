param (
        [Alias('s')][string]
        $SourceKeyVaultName,
        [Alias('d')][string]
        $DestinationKeyVaultName,
        [Alias('n')][string]
        $SecretName,
        [string]
        $DestinationSecretName = "VOIDVOIDVOID"
    )
Function IIf($If, $Right, $Wrong) {If ($If) {$Right} Else {$Wrong}}

 $SourceSecret = Get-AzKeyVaultSecret -VaultName $SourceKeyVaultName -Name $SecretName
 Set-AzKeyVaultSecret -VaultName $DestinationKeyVaultName -Name (&{If($DestinationSecretName -eq "VOIDVOIDVOID"){$SecretName} else {$DestinationSecretName}}) -SecretValue $SourceSecret.SecretValue