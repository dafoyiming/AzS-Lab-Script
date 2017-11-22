$tempEncryptionKeyString = ""

foreach ($i in 1..64) {
 $tempEncryptionKeyString += -join ((65..90) + (97..122) | 
Get-Random | 
% {[char]$_})
}

$tempEncryptionKeyBytes = ` [System.Text.Encoding]::UTF8.GetBytes($tempEncryptionKeyString)

$BackupEncryptionKeyBase64 = ` [System.Convert]::ToBase64STring($tempEncryptionKeyBytes)
$BackupEncryptionKeyBase64
