#!/bin/bash
# Jason Quiroga

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {

	echo ""
	echo "Invalid Option"
	echo ""
	sleep 2

}

function menu() {

	# Clears the screen when you start this menu
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 
		
		1) admin_menu
		;;

		2) security_menu
		;;

		3) exit 0
		;;

		*) invalid_opt 
			menu
		;;
	esac

}

function admin_menu() {

	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l) ps -ef | less
		;;
		N|n) netstat -an --inet | less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*) 
			invalid_opt
		;;
	esac
admin_menu
}

function vpn_menu() {

	clear
	echo "[A]dd a user"
	echo "[D]elete a user"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

		A|a) 
			bash peer.bash
			tail -6 wg0.conf | less
		;;
		D|d) 
			read -p "Please specify a user to delete: " user
			bash manage-users.bash -d -u ${user} | less

		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*) 
			invalid_opt
		;;
	esac
vpn_menu
}

function security_menu {

	clear
	echo "[L]ist Open Network Sockets"
	echo "[C]heck for Users with UID of 0 Besides Root"
	echo "[N]ame Last 10 Users Logged in"
	echo "[S]ee Currently Logged in Users"
	echo "[1] Cisco Blocklist Generator"
	echo "[2] Domain URL Blocklist Generator"
	echo "[3] Netscreen Blocklist Generator"
	echo "[4] Windows Blocklist Generator"
	echo "[M]ain Menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

		L|l) ss -lp | less
		;;
		C|c) 
			echo ""
			echo "Users with a UID of 0:"
			echo ""
			cat /etc/passwd | grep 0:0
			sleep 3
		;;
		N|n) last -10 | less
		;;
		S|s) w | less
		;;
		1) 
			bash parse-threat.bash -c 
			sleep 5
		;;
		2) 
			bash parse-threat.bash -p
			sleep 5
		;;
		3) 
			bash parse-threat.bash -n 
			sleep 5
		;;
		4) 
			bash parse-threat.bash -f 
			sleep 5
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*)
			invalid_opt
		;;
	esac
security_menu
}

# Call the main function
menu
