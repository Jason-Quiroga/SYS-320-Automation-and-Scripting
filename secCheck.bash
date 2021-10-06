#!/bin/bash

# Script for local security checks

function checks() {

	if [[ $2 != $3 ]]
	then
		echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is $3.\e[0m"
		echo -e "The remediation to this is:\n$4."
	else
		echo -e "\e[1;32mThe $1 is compliant. Current value is: $3\e[0m"
	fi
}

function checks2() {
	
	if [[ $2 == $5 || $3 == $6 || $4 == $7 ]]
	then
		echo -e "\e[1;31mThe $1 is not compliant. Please see below to fix.\e[0m"
		echo -e "The remediation to this is:\n$8"

	else
		echo -e "\e[1;32mThe $1 is compliant.\e[0m"

	fi
}

# Assign the variable pmax with the value of "PASS_MAX_DAYS" in /etc/login.defs
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')

# Check for the password max
#	Name of the Policy	What it should be	What it is
checks "Password Max Days"            "365" 		 "${pmax}" "Set the value to 365"

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Minimum Days" "14" "${pmin}" "Set the value to 14"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}" "Set the value to 7"

# Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i '^UsePAM' /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "UsePAM" "yes" "${chkSSHPAM}" "Set the value to yes"

# Check permissions on users' home directory
for eachDir in $(ls -l /home/ | egrep '^d' | awk ' { print $3 } ' )
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ' )
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}" "Set the value to drwx------"
done

# Ensure IP forwarding is disabled
chkIPfrwd=$(grep "net.ipv4.ip_forward" /etc/sysctl.conf | cut -d\= -f2)
checks "IP Forwarding" "0" "${chkIPfrwd}" "Run the commands:\nsysctl -w net.ipv4.ip forward=0\nsysctl -w net.ipv4.route.flush=1"

# Ensure ICMP redirects are not accepted
chkICMP=$(egrep "net.ipv4.conf.all.accept_redirects" /etc/sysctl.conf | awk ' { print $3 } ')
checks "ICMP Redirects" "0" "${chkICMP}" "Set the following parameters in /etc/sysctl1.conf\nnet.ipv4.conf.all.accept redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0"

# Ensure permissions on /etc/crontab are configured
chkCronTab1=$(stat /etc/crontab | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "..../...------") # We do not want this to be ""
chkCronTab2=$(stat /etc/crontab | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkCronTab3=$(stat /etc/crontab | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

		#Policy Name	1  2  3       argument1	      argument2		argument3	solution
checks2 "Crontab Configured" "" "" "" "${chkCronTab1}" "${chkCronTab2}" "${chkCronTab3}" "Run the following commands and set ownership and permissions on /etc/crontab:\nchwon root:root /etc/crontab\nchmod og-rwx /etc/crontab"

# Ensure permissions on /etc/cron.hourly are configured
chkCronHour1=$(stat /etc/cron.hourly | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "..../...------") # We do not want this to be ""
chkCronHour2=$(stat /etc/cron.hourly | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkCronHour3=$(stat /etc/cron.hourly | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Cron.hourly Configured" "" "" "" "${chkCronHour1}" "${chkCronHour2}" "${chkCronHour3}" "Run the following commands to set ownership and permissions on /etc/cron.hourly:\nchown root:root /etc/cron.hourly\nchmod og-rwx /etc/cron.hourly"

# Ensure permissions on /etc/cron.daily are configured
chkCronDay1=$(stat /etc/cron.daily | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "..../...------") # We do not want this to be ""
chkCronDay2=$(stat /etc/cron.daily | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkCronDay3=$(stat /etc/cron.daily | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Cron.daily Configured" "" "" "" "${chkCronDay1}" "${chkCronDay2}" "${chkCronDay3}" "Run the following commands to set ownership and permissions on /etc/cron.daily:\nchown root:root /etc/cron.daily\nchmod og-rwx /etc/cron.daily"

# Ensure permissions on /etc/cron.weekly are configured
chkCronWeek1=$(stat /etc/cron.weekly | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "..../...------") # We do not want this to be ""
chkCronWeek2=$(stat /etc/cron.weekly | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkCronWeek3=$(stat /etc/cron.weekly | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Cron.weekly Configured" "" "" "" "${chkCronWeek1}" "${chkCronWeek2}" "${chkCronWeek3}" "Run the following commands to set ownership and permissions on /etc/cron.weekly:\nchown root:root /etc/cron.weekly\nchmod og-rwx /etc/cron.weekly"

# Ensure permissions on /etc/cron.monthly are configured
chkCronMonth1=$(stat /etc/cron.monthly | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "..../...------") # We do not want this to be ""
chkCronMonth2=$(stat /etc/cron.monthly | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkCronMonth3=$(stat /etc/cron.monthly | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Cron.monthly Configured" "" "" "" "${chkCronMonth1}" "${chkCronMonth2}" "${chkCronMonth3}" "Run the following commands to set ownership and permissions on /etc/cron.monthly:\nchown root:root /etc/cron.monthly\nchmod og-rwx /etc/cron.monthly"

# Ensure permissions on /etc/passwd are configured
chkPasswd=$(stat /etc/passwd | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "0644") # We do not want this to be ""
checks "Passwd Configured" "(0644/-rw-r--r--)" "${chkPasswd}" "Run the following command to set permissions on /etc/passwd:\nchown root:root /etc/passwd\nchmod 644 /etc/passwd"

# Ensure permissions on /etc/shadow are configured
chkShadow1=$(stat /etc/shadow | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0640/-rw-r-----)") # We do not want this to be ""
chkShadow2=$(stat /etc/shadow | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkShadow3=$(stat /etc/shadow | egrep "^Access: \(" | egrep "Gid: \(    0/    shadow\)") # We don't want this to be ""

checks2 "Shadow Configured" "" "" "" "${chkShadow1}" "${chkShadow2}" "${chkShadow3}" "Run the following commands to set ownership and permissions on /etc/shadow:\nchown root:shadow /etc/shadow\nchmod o-rwx,g-wx /etc/cron.shadow"

# Ensure permissions on /etc/group are configured
chkGroup1=$(stat /etc/group | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0644/-rw-r--r--)") # We do not want this to be ""
chkGroup2=$(stat /etc/group | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkGroup3=$(stat /etc/group | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Group Configured" "" "" "" "${chkGroup1}" "${chkGroup2}" "${chkGroup3}" "Run the following commands to set ownership and permissions on /etc/group:\nchown root:root /etc/group\nchmod 644 /etc/group"


# Ensure permissions on /etc/gshadow are configured
chkGShadow1=$(stat /etc/gshadow | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0640/-rw-r-----)") # We do not want this to be ""
chkGShadow2=$(stat /etc/gshadow | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkGShadow3=$(stat /etc/gshadow | egrep "^Access: \(" | egrep "Gid: \(   42/  shadow\)") # We don't want this to be ""

checks2 "GShadow Configured" "" "" "" "${chkGShadow1}" "${chkGShadow2}" "${chkGShadow3}" "Run the following commands to set ownership and permissions on /etc/gshadow:\nchown root:shadow /etc/gshadow\nchmod o-rwx,g-rw /etc/gshadow"

# Ensure permissions on /etc/passwd- are configured
chkPasswdd1=$(stat /etc/passwd- | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0644/-rw-r--r--)") # We do not want this to be ""
chkPasswdd2=$(stat /etc/passwd- | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkPasswdd3=$(stat /etc/passwd- | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Passwd- Configured" "" "" "" "${chkPasswdd1}" "${chkPasswdd2}" "${chkPasswdd3}" "Run the following commands to set ownership and permissions on /etc/shadow-:\nchown root:root /etc/passwd-\nchmod u-x,go-wx /etc/passwd-"

# Ensure permissions on /etc/shadow- are configured
chkShadowd1=$(stat /etc/shadow- | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0640/-rw-r-----)") # We do not want this to be ""
chkShadowd2=$(stat /etc/shadow- | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkShadowd3=$(stat /etc/shadow- | egrep "^Access: \(" | egrep "Gid: \(   42/  shadow\)") # We don't want this to be ""

checks2 "Shadow- Configured" "" "" "" "${chkShadowd1}" "${chkShadowd2}" "${chkShadowd3}" "Run the following commands to set ownership and permissions on /etc/shadow-:\nchown root:shadow /etc/shadow-\nchmod o-rwx,g-rw /etc/shadow-"

# Ensure permissions on /etc/group- are configured
chkGroupd1=$(stat /etc/group- | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0644/-rw-r--r--)") # We do not want this to be ""
chkGroupd2=$(stat /etc/group- | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkGroupd3=$(stat /etc/group- | egrep "^Access: \(" | egrep "Gid: \(    0/    root\)") # We don't want this to be ""

checks2 "Group- Configured" "" "" "" "${chkGroupd1}" "${chkGroupd2}" "${chkGroupd3}" "Run the following commands to set ownership and permissions on /etc/group-:\nchown root:root /etc/group-\nchmod u-x,go-wx /etc/group-"

# Ensure permissions on /etc/gshadow- are configured
chkGShadowd1=$(stat /etc/gshadow- | egrep "^Access: \(" | awk ' { print $2 } ' | egrep "(0640/-rw-r-----)") # We do not want this to be ""
chkGShadowd2=$(stat /etc/gshadow- | egrep "^Access: \(" | egrep "Uid: \(    0/    root\)") # We don't want this to be ""
chkGShadowd3=$(stat /etc/gshadow- | egrep "^Access: \(" | egrep "Gid: \(   42/  shadow\)") # We don't want this to be ""

checks2 "GShadow- Configured" "" "" "" "${chkGShadowd1}" "${chkGShadowd2}" "${chkGShadowd3}" "Run the following commands to set ownership and permissions on /etc/gshadow-:\nchown root:shadow /etc/gshadow-\nchmod o-rwx,g-rw /etc/gshadow-"

# Ensure no legacy "+" entries exist on /etc/passwd
chkPasswdp=$(egrep '^\+:' /etc/passwd)
checks "No Legacy + in passwd" "" "${chkPasswdp}" "Remove any legacy '+' entries from /etc/passwd if they exist"

# Ensure no legacy "+" entries exist on /etc/shadow
chkShadowp=$(sudo egrep '^\+:' /etc/shadow)
checks "No Legacy + in shadow" "" "${chkShadowp}" "Remove any legacy '+' entries from /etc/shadow if they exist"

# Ensure no legacy "+" entries exist on /etc/group
chkGroupp=$(egrep '^\+:' /etc/group)
checks "No Legacy + in group" "" "${chkGroupp}" "Remove any legacy '+' entries from /etc/group if they exist"

# Ensure root is the only UID 0 account
chkUID=$(cat /etc/passwd | egrep 0:0 | egrep -v '^root')
checks "No Users with UID of 0 Besides Root" "" "${chkUID}" "Remove any users other than root with UID 0 or assign them a new UID if appropriate"

