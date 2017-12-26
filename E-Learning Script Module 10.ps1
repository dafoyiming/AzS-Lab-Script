http://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.vhd.zip

Install-Module -Name AzureRm.BootStrapper
Use-AzureRmProfile -Profile 2017-03-09-profile -Force
Install-Module -Name AzureStack -RequiredVersion 1.2.10


Set-Location -Path 'C:\'
Invoke-WebRequest -Uri https://github.com/Azure/AzureStack-Tools/archive/master.zip ` -OutFile master.zip
Expand-Archive -Path .\master.zip -DestinationPath . -Force
Set-Location -Path C:\AzureStack-Tools-master

Import-Module .\Connect\AzureStack.Connect.psm1
Import-Module .\ComputeAdmin\AzureStack.ComputeAdmin.psm1

Add-AzureRMEnvironment `
  -Name "AzureStackAdmin" `
  -ArmEndpoint "https://adminmanagement.local.azurestack.external"

Set-AzureRmEnvironment `
	-Name 'AzureStackAdmin' `
	-GraphAudience 'https://graph.local.azurestack.external/' `
	-EnableAdfsAuthentication:$true

$TenantID = Get-AzsDirectoryTenantId `
  -ADFS `
  -EnvironmentName AzureStackAdmin

$adminUserName = 'AzureStackAdmin@azurestack.local'
$adminPassword = 'Pa55w.rd' | ConvertTo-SecureString -Force -AsPlainText
$adminCredentials = New-Object PSCredential($adminUserName,$adminPassword)

Login-AzureRmAccount -EnvironmentName 'AzureStackAdmin' `
        		-TenantId $tenantID `
 		     	-Credential $adminCredentials

$vhdPath = "C:\Downloads\<name of the VHD file downloaded above>"

Add-AzsVMImage `
  -publisher 'Canonical' `
  -offer 'UbuntuServer' `
  -sku '16.04-LTS' `
  -version '1.0.0' `
  -osType Linux `
  -osDiskLocalPath $vhdPath