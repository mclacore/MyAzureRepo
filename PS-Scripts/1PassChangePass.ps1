#Set variables
$1PSignInAddress = ""
$1PSignInAccount = ""
$1PSecretKey = ConvertTo-SecureString "" -AsPlainText -Force
$1PMasterPassword = ConvertTo-SecureString "" -AsPlainText -Force
$1PVault = "TestVault"
$1PItem = "TestAccount"
$Objectid = ''
$smtpfrom = ''
$smtpto = ''
$smtpserver = ''
$subject = 'Monthly Account Password Change'
$body = 'The password for' + $1PItem + 'account has been changed. Please check' + $1PVault + '1Password vault for updated password.'

#Importing modules
Write-Output "Loading 1Pwd Module"
Import-Module -name 1Pwd
Write-Output "Loading Az Module"
Import-Module -name Az

#Connecting to 1Pwd
$account = Test-1PasswordCredentials -SignInAddress $1PSignInAddress -SignInAccount $1PSignInAccount -SecretKey $1PSecretKey -MasterPassword $1PMasterPassword
Set-1PasswordConfiguration -SignInAddress $1PSignInAddress -SignInAccount $1PSignInAccount -SecretKey $1PSecretKey -MasterPassword $1PMasterPassword -Default
Invoke-1PasswordExpression "list vaults"

#Set variable for new password
$NewPassword = ((Invoke-1PasswordExpression "get item TestAccount").details.fields | where-object {$_.designation -eq 'password'} | select-object -property value).value

#Change password for Azure account
Set-AzureADUserPassword -ObjectId $ObjectId -Password $NewPassword

#Send notification to email group about password change
Send-MailMessage -From $smtpfrom -To $smtpto -Subject $Subject -body $body -SmtpServer $smtpServer -port 25
