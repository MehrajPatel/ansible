#param ($username, $password)  <-- uncomment this when powershell upgrade is required

#opend windows internal firewall
New-NetFirewallRule -DisplayName "ALLOW TCP PORT 22" -Direction inbound -Profile Any -Action Allow -LocalPort 22 -Protocol TCP
New-NetFirewallRule -DisplayName "ALLOW TCP PORT 5985" -Direction inbound -Profile Any -Action Allow -LocalPort 5985 -Protocol TCP
New-NetFirewallRule -DisplayName "ALLOW TCP PORT 5986" -Direction inbound -Profile Any -Action Allow -LocalPort 5986 -Protocol TCP


#Install ssh to windows
#Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

#Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# Start sssh service automatically on startup
Set-Service -Name sshd -StartupType 'Automatic'

#upgrade and configure powershell
# $url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
# $file = "$env:temp\Upgrade-PowerShell.ps1"
# (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
# &$file -Version 5.1 -Username $username -Password $password -Verbose

#To configure WinRM on a Windows system with ansible
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file
winrm enumerate winrm/config/Listener

#Set winrm to allow HTTP traffic.
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

#Set the authentication to basic in wirm
winrm set winrm/config/service/auth '@{Basic="true"}'
