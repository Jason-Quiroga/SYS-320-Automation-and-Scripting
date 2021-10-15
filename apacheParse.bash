#!/bin/bash

#Parse Apache Log

#Read in file

#Arguments using the position, they start at $1
APACHE_LOG="$1"

#Check if the file exists
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to a log file."
	exit 1
fi

# Looking for web scanners
#sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
#egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
#awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
#				printf format, "IP", "Date", "Method", "Status", "Size", "URI"
#				printf format, "--", "----", "------", "------", "----", "---"
#}
#
#{ printf format, $1, $4, $6, $9, $10, $7 }'

#Check to see if iptables.ruleset or windows.ruleset exist, and if so, delete them so that we don't create a huge file with repeats.
if [[ -f "iptables.ruleset" ]]
then
	rm iptables.ruleset
fi

if [[ -f "windows.ruleset" ]]
then
	rm windows.ruleset
fi

# Parse the Apache Logs and create an IPTables Ruleset and a Windows Firewall Rule using Powershell
awk ' { print $1 } ' ${APACHE_LOG} | sort -u | tee ips.temp # Format so only the IPs are in the file
for eachip in $(cat ips.temp)
do
	echo "iptables -a input -s ${eachip} -j drop" | tee -a iptables.ruleset
	echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a windows.ruleset
	#First echo is iptables, second is windows
done

rm ips.temp #Removes the temporary formatted file with just IPs

clear

echo "Created IPTables firewall drop rules in file \"iptables.ruleset\" and Windows Firewall Rules in \"windows.ruleset\""
