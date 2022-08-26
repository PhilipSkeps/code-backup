#!/bin/bash

Connect () 
{
cd "$HOME/OpenVPNProfiles"
sudo openvpn --config mines.ovpn --auth-user-pass --daemon
if [ "$(ip link show | grep -q 'tun0')"==0 ]; then
	echo -e "\e[36mYou are Connected to the Colorado School of Mines VPN"
	echo '~~~~~To Disconnect use the --disconnect Option~~~~~'
else
	echo "\e[36mYou Failed to Connect to the Colorado School of Mines VPN\e[5m"
fi || True
}

Disconnect () 
{
sudo killall openvpn
}

if [ -z "$1" ]; then
	Connect
fi
if [ "$1" == --disconnect ] && [ $(ip link show | grep -q 'tun0')==0 ]; then
	Disconnect
fi 
