$ipAddress = (Resolve-DnsName -Name AzS-ERCS01).IPAddress

$trustedHosts = (Get-Item -Path WSMan:\localhost\Client\TrustedHosts).Value
If ($trustedHosts -ne '*') {
 If ($trustedHosts -ne '') {
  $trustedHosts += ",ipAddress"
 } else {
 $trustedHosts = "$ipAddress"
 }
}
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $TrustedHosts -Force

$adminUserName = 'AzureStackAdmin@azurestack.local'
$adminPassword = 'Pa55w.rd' | ConvertTo-SecureString -Force -AsPlainText
$adminCredentials = New-Object PSCredential($adminUserName,$adminPassword)

Enter-PSSession -ComputerName $ipAddress -ConfigurationName -PrivilegedEndpoint -Credential $adminCredentials