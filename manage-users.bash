#!/bin/bash

# Storyline: Script to add and delete VPN peers

while getopts 'hdau:c' OPTION ; do

	case "$OPTION" in

		d) u_del=${OPTION}
		;;
		a) u_add=${OPTION}
		;;
		u) t_user=${OPTARG}
		;;
		h)
			# This is our help line of code, it tells the user how to use the command.
			# $(basename $0) will return the name of the bash script.
			echo ""
			echo "Usage: $(basename $0) [-a]|[-d] -u username"
			echo ""
			exit 1
		;;
		c) u_check=${OPTION}
		;;
		*)
			echo "Invalid value."
			exit 1
		;;
	esac
done

# Check to see if -a and -d and -u are empty, or if a and d are both  specified, throw an error
if [[ (${u_del} == "" && ${u_add} == "" && ${u_check} == "") || (${u_del} != "" && ${u_add} != "")  ]]
then
	echo "Please specify -a or -d and the -u and username."
fi

# Check to ensure -u is specified
if [[ (${u_del} != "" || ${u_add} != "" || ${u_check} != "") && ${t_user} == ""  ]]
then
	echo "Please specify a user (-u)."
	echo "Usage: $(basename $0) [-a]|[-d] [-u username]"
	exit 1
fi

# Delete a user
if [[ ${u_del} ]]
then
	echo "Deleting user..."
	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

# Add a user
if [[ ${u_add} ]]
then
	echo "Creating the User..."
	bash peer.bash ${t_user}
fi

# Check to see if a user exists
if [[ ${u_check}  ]]
then
	result=$(cat wg0.conf | grep ${t_user})
	if [[ ${result} != ""  ]]
	then
		echo "The user ${t_user} exists."
	else
		echo "The user ${t_user} does not exist."
	fi
fi
