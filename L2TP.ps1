# VPN Connection ‘L2TP’ provisioning 

#------------------------------------------------------------
#Get Params from the Switchboard action like VirtualIP
param (
    [string]$server = ""
)

#------------------------------------------------------------
# VPN Connection look-up to check any previous installations


$isTestVpn = $false
#Get all VPN Connection for the local user instead of AllUserConnection
#$vpnConnections = Get-VpnConnection -AllUserConnection
$vpnConnections = Get-VpnConnection


if($vpnConnections.Name -eq "L2TP")
{
	try{
		Write-Host "'L2TP' connection is already configured on your system." -ForegroundColor Yellow -BackgroundColor DarkGreen
		try{
			Write-Host "I'll update the L2TP ServerAddress, please wait..." -ForegroundColor Black -BackgroundColor Yellow
			Write-Host ""
			Set-VpnConnection -Name "L2TP" -ServerAddress $server -L2tpPsk "MyPre-Sharedkey" -TunnelType "L2TP" -RememberCredential $True -EncryptionLevel Optional -AuthenticationMethod Pap -Force
		}
		catch{
			Write-Host "Error during the connection" -ForegroundColor White -BackgroundColor Red
			Write-Host $_.Exception.Message
			throw
		}
		Write-Host "We try now to start the VPN Connection" -ForegroundColor Yellow -BackgroundColor DarkGreen
		Write-Host ""
		rasdial L2TP MyUsername MyPassword
		exit
	}
	catch{
		Write-Host "Error during the connection" -ForegroundColor White -BackgroundColor Red
		Write-Host $_.Exception.Message
		throw
	}
}

Write-Host "******************************************" -ForegroundColor Black -BackgroundColor White
Write-Host "      Installing 'L2TP’ connection      " -ForegroundColor Black -BackgroundColor White
Write-Host "__________________________________________" -ForegroundColor Black -BackgroundColor White

try
{
    # Create the VPN connection
    #Add-VpnConnection -Name "L2TP" -ServerAddress "contoso.com" -L2tpPsk ""MyPre-Sharedkey"" -TunnelType "L2TP" -RememberCredential $True -EncryptionLevel Optional -AuthenticationMethod Pap
	Add-VpnConnection -Name "EL2TP" -ServerAddress $server -L2tpPsk ""MyPre-Sharedkey"" -TunnelType "L2TP" -RememberCredential $True -EncryptionLevel Optional -AuthenticationMethod Pap -Force
}
catch
{
    Write-Host "Error in connection setup!" -ForegroundColor White -BackgroundColor Red
    Write-Host $_.Exception.Message
    throw
}

Write-Host ""
Write-Host "‘L2TP’ VPN connection is ready for use." -ForegroundColor Black -BackgroundColor White
Write-Host ""
Write-Host "We try now to start the VPN Connection" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host ""
rasdial L2TP MyUsername MyPassword
exit
