#!/bin/bash

# Target input check
if [ $# -eq 0 ]
then
	echo -e 'Please specify the target domain.\n'
	echo -e 'Usage:'
	echo -e '\t$0 <domain>'
	exit 1
else
	domain=$1

fi

# Nmap online scan
function nmap_online_scan {
	echo -e '\n[+] Saving Nmap online scan output to <scan_'$domain'\ nmap_pn_'$domain'.txt> file\n'
	nmap -Pn $domain -p$port | tee ./scan_$domain/nmap_pn_$domain.txt
}

#Nmap script scan
function nmap_script_scan {
	echo -e '\n[+] Saving Nmap script scan output to <scan_'$domain'\ nmap_script_'$domain'.txt> file\n'
        nmap -sC -sV $domain -p$port | tee ./scan_$domain/nmap_script_$domain.txt
}

#Nmap A scan
function nmap_A_scan {
	echo -e '\n[+] Saving Nmap OS detection scan output to <scan_'$domain'\ nmap_a_'$domain'.txt> file\n'
        nmap -A $domain -p$port | tee ./scan_$domain/nmap_a_$domain.txt
}

#Nmap UDP scan
function nmap_UDP_scan {
        echo -e '\n[+] Saving Nmap UDP scan output to <scan_'$domain'\ nmap_udp_'$domain'.txt> file\n'
        nmap -A $domain -p$port | tee ./scan_$domain/nmap_udp_$domain.txt
}

#Nmap all scans
function nmap_all_scans {
	nmap_online_scan
	nmap_script_scan
	nmap_A_scan
	nmap_UDP_scan

}

#Nmap def scan with a port range
function nmap_def_port {
	echo -e '\n[+] Saving Nmap online scan output to <scan_'$domain'\ nmap_def_port_'$domain'.txt> file\n'
        nmap $domain -p$port | tee ./scan_$domain/nmap_def_port_$domain.txt
}

# Creating output folder
clear
mkdir scan_$domain > /dev/null 2>&1

# Ping with txt output
echo -e '\n[+] Saving ping output to <scan_'$domain'\ ping_'$domain'.txt> file\n'
ping -c 4 $domain | tee ./scan_$domain/ping_$domain.txt

# Nmap default scan with txt output
echo -e '\n[+] Saving Nmap default scan output to <scan_'$domain'\ nmap_def_'$domain'.txt> file\n'
nmap $domain | tee ./scan_$domain/nmap_def_$domain.txt

# Custom scan prompt

echo -e '\nDo you want to run a custom Nmap scan?'
echo -e '\t1) Skip discovery scan (-Pn)'
echo -e '\t2) Defaul script scan with the version information (-sC -sV)'
echo -e '\t3) Enable OS detection, version detection, script scanning, and traceroute (-A)'
echo -e '\t4) UDP scan'
echo -e '\t5) Default scan with a custom port range'
echo -e '\t6) Scans 1-4'
echo -e '\t7) Exit'

read -p 'Select your option: ' nmap_opt

#Exit check
if (( $nmap_opt < 1 )) || (( $nmap_opt > 6 ))
then
	exit 0
fi

# Nmap port input

echo -e '\nEnter a single port number or port numbers separated by:'
echo -e '"," for more than one port scan [ex. 21,22,80]'
echo -e '"-" for port range [ex. 100-500]'
read -p 'Port(s): ' port
clear

case $nmap_opt in

	'1') nmap_online_scan ;;
	'2') nmap_script_scan ;;
	'3') nmap_A_scan ;;
	'4') nmap_UDP_scan ;;
	'5') nmap_def_port ;;
	'6') nmap_all_scans ;;
	'*') exit 0 ;;
esac


