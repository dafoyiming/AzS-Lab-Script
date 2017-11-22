Install-Module -Name AzureRm.BootStrapper
Use-AzureRmProfile -Profile 2017-03-09-profile -Force
Install-Module -Name AzureStack -RequiredVersion 1.2.10


Set-Location -Path 'C:\AzureStack-Tools-brbartle-registerwithmodule'
Get-ChildItem -Path '.\' -Recurse -File | Unblock-File

Import-Module -Name .\Connect\AzureStack.Connect.psm1
Import-Module -Name .\ComputeAdmin\AzureStack.ComputeAdmin.psm1

Add-AzureRmEnvironment -Name 'AzureStackAdmin' `
        -ArmEndpoint 'https://adminmanagement.local.azurestack.external'

Set-AzureRmEnvironment `
 -Name 'AzureStackAdmin' `
 -GraphAudience 'https://graph.local.azurestack.external/' `
 -EnableAdfsAuthentication:$true

$tenantID = Get-AzsDirectoryTenantId `
  -ADFS `
  -EnvironmentName 'AzureStackAdmin'
$adminUserName = 'AzureStackAdmin@azurestack.local'
$adminPassword = 'Pa55w.rd' | ConvertTo-SecureString -Force -AsPlainText
$adminCredentials = New-Object PSCredential($adminUserName,$adminPassword)

Login-AzureRmAccount -EnvironmentName 'AzureStackAdmin' `
          -TenantId $tenantID `
         -Credential $adminCredentials