param (
        [Alias('s')][string]
        $SourceKeyVaultName,
        [Alias('d')][string]
        $DestinationKeyVaultName,
        [Alias('n')][string]
        $SecretName,
        [string]
        $DestinationSecretName = ""
    )
Function IIf($If, $Right, $Wrong) {If ($If) {$Right} Else {$Wrong}}

 $SourceSecret = Get-AzKeyVaultSecret -VaultName $SourceKeyVaultName -Name $SecretName
 Set-AzKeyVaultSecret -VaultName $DestinationKeyVaultName -Name (&{If($DestinationSecretName -eq ""){$SecretName} else {$DestinationSecretName}}) -SecretValue $SourceSecret.SecretValue
