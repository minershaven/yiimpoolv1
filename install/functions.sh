#!/bin/bash

##############################################
#											 #
# Current Modified by Afiniel (2022-06-06)   #
# Updated by Afiniel (2022-08-01)			 #
# 											 #
##############################################

source /etc/yiimpoolversion.conf

absolutepath=absolutepathserver
installtoserver=installpath
daemonname=daemonnameserver
#DISTRO=distroserver

ESC_SEQ="\x1b["
NC=${NC:-"\033[0m"} # No Color
RED=$ESC_SEQ"31;01m"
GREEN=$ESC_SEQ"32;01m"
YELLOW=$ESC_SEQ"33;01m"
BLUE=$ESC_SEQ"34;01m"
MAGENTA=$ESC_SEQ"35;01m"
CYAN=$ESC_SEQ"36;01m"

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    while ps -p $pid > /dev/null 2>&1; do
        for char in $spinstr; do
            printf " [%c] " "$char"
            sleep $delay
            printf "\b\b\b\b\b\b\b"
        done
    done
    printf "\b\b\b\b\b\b\b"
    echo -e "\033[0;32mDone\033[0m"
}



# Database functions
function database_import_sql {

	# Import Database from SQL files
	sleep 1
	echo -e "$CYAN Importing Database from SQL files <= ${NC}"

	echo
	cd ~
	cd yiimp/sql

	# YAAMP.sql.gz import
	sudo zcat 2020-11-10-yaamp.sql.gz | sudo mysql --defaults-group-suffix=host1

	# Rest of the SQL files import (if any)
    sudo mysql --defaults-group-suffix=host1 --force < 2016-04-24-market_history.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-04-27-settings.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-11-coins.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-15-benchmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-23-bookmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-06-01-notifications.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-06-04-bench_chips.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-11-23-coins.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-02-05-benchmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-03-31-earnings_index.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2020-06-03-blocks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-05-accounts_case_swaptime.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-06-payouts_coinid_memo.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-09-notifications.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-10-bookmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2018-09-22-workers.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-11-segwit.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2018-01-stratums_ports.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2018-02-coins_getinfo.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2019-03-coins_thepool_life.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2022-10-14-shares_solo.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2022-10-29-blocks_effort.sql

	echo -e "$GREEN Database imported successfully!${NC}"

}

# terminal art end screen.

function install_end_message() {

  clear

  # Define color codes (avoid hardcoding in the function)
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BOLD_YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  BOLD_CYAN='\033[1;36m'
  NC='\033[0m'  # Reset color

  echo "Yiimp Installation Complete!"
  echo

  figlet -f slant -w 100 "Success"

  echo -e "${BOLD_GREEN}**Yiimp Version:**${NC} $VERSION"
  echo

  echo -e "${BOLD_CYAN}**Database Information:**${NC}"
  echo "  - Login credentials are saved securely in ~/.my.cnf"
  echo

  echo -e "${BOLD_CYAN}**Pool and Admin Panel Access:**${NC}"
  echo "  - Pool: http://$server_name"
  echo "  - Admin Panel: http://$server_name/site/AdminPanel"
  echo "  - phpMyAdmin: http://$server_name/phpmyadmin"
  echo

  echo -e "${BOLD_CYAN}**Customization:**${NC}"
  echo "  - To modify the admin panel URL (currently set to '$admin_panel'):"
  echo "    - Edit ${BOLD_YELLOW}/var/web/yaamp/modules/site/SiteController.php${NC}"
  echo "    - Update line 11 with your desired URL"
  echo

  echo -e "${BOLD_CYAN}**Security Reminders:**${NC}"
  echo "  - Update public keys and wallet addresses in ${BOLD_YELLOW}/var/web/serverconfig.php${NC}"
  echo "  - Replace placeholder private keys in ${BOLD_YELLOW}/etc/yiimp/keys.php${NC} with your actual keys"
  echo "    - ${RED}Never share your private keys with anyone!${NC}"
  echo

  echo -e "${BOLD_YELLOW}**Next Steps:**${NC}"
  echo "  1. Reboot your server to finalize the installation process. ( ${RED}reboot${NC} )"
  echo "  2. Secure your installation by following best practices for server security."
  echo

  echo "Thank you for using the Yiimp Installer Script Fork by Afiniel!"

}

# terminal art start screen.
term_art() {
  clear

  # Define color codes (assuming they are not already defined)
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BOLD_YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  BOLD_CYAN='\033[1;36m'
  NC='\033[0m'  # No Color

  # Calculate centered text with dashes for a modern border
  num_cols=$(tput cols)
  half_cols=$((num_cols / 2))
  offset=$(( (half_cols - 16) / 2 ))  # Adjust offset for even spacing

  # Print top border
  printf "%${offset}s" " "
  echo -e "${BOLD_YELLOW}╔══════════════════════════════╗${NC}"

  # Print Yiimp Installer title
  printf "%${offset}s" " "
  echo -e "${BOLD_YELLOW}║  ${BOLD_CYAN}Yiimp Installer Script${BOLD_YELLOW}  ║${NC}"

  # Print subtitle
  printf "%${offset}s" " "
  echo -e "${BOLD_YELLOW}║${BOLD_CYAN}        Fork By Afiniel!${BOLD_YELLOW} ║${NC}"

  # Print bottom border
  printf "%${offset}s" " "
  echo -e "${BOLD_YELLOW}╚════════════════════════════╝${NC}"
  echo  # New line for spacing

  # Print main content
  echo
  echo -e "${BOLD_YELLOW}                      Welcome to the Yiimp Installer!${NC}"
  echo
  echo -e "${BOLD_YELLOW}  This script will install all dependencies and Yiimp for you, including:${NC}"
  echo -e "${BOLD_YELLOW}    - MySQL for database management${NC}"
  echo -e "${BOLD_YELLOW}    - Nginx web server with PHP for Yiimp operation${NC}"
  echo -e "${BOLD_YELLOW}    - MariaDB as the database backend${NC}"
  echo
  echo -e "${BOLD_YELLOW}  **Version:** ${GREEN}$VERSION${NC}"
  echo
}



function term_yiimpool {
	clear
	source /etc/functions.sh
	source /etc/yiimpool.conf
	figlet -f slant -w 100 "YiimpooL" | lolcat
	echo -e "$CYAN   -----------------|--------------------- 	  											${NC}"
	echo -e "$YELLOW  Yiimp Installer Script Fork By Afiniel!												${NC}"
	echo -e "$YELLOW  Version:${NC} $GREEN $VERSION 											${NC}"
	echo -e "$CYAN   -----------------|--------------------- 	  			${NC}"
	echo

}

function daemonbuiler_files {
	echo -e "$YELLOW Copy => Copy Daemonbuilder files.  <= ${NC}"
	cd $HOME/Yiimpoolv2
	sudo mkdir -p /etc/utils/daemon_builder
	sudo cp -r utils/start.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu2.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu3.sh $HOME/utils/daemon_builder
	# sudo cp -r utils/errors.sh $HOME/utils/daemon_builder
	sudo cp -r utils/source.sh $HOME/utils/daemon_builder
	sudo cp -r utils/upgrade.sh $HOME/utils/daemon_builder
	# sudo cp -r utils/stratum.sh $HOME/utils
	sleep 0.5
	echo '
	#!/usr/bin/env bash
	source /etc/functions.sh # load our functions
	cd $STORAGE_ROOT/daemon_builder
	bash start.sh
	cd ~
	' | sudo -E tee /usr/bin/daemonbuilder >/dev/null 2>&1
	sudo chmod +x /usr/bin/daemonbuilder
	echo
	echo -e "$GREEN => Complete${NC}"
	sleep 2
}

hide_output() {
    local OUTPUT=$(mktemp)
    "$@" &>"$OUTPUT" &
    local pid=$!

    # Run spinner function in the background
    spinner $pid

    wait $pid # Wait for the background process to finish
    local exit_status=$?

    if [ $exit_status != 0 ]; then
        echo " "
        echo "FAILED: $@"
        echo "-----------------------------------------"
        cat "$OUTPUT"
        echo "-----------------------------------------"
        rm -f "$OUTPUT"
        exit $exit_status
    fi

    rm -f "$OUTPUT"
}


function last_words {
	echo "<-------------------------------------|---------------------------------------->"
	echo
	echo -e "$YELLOW Thank you for using the Yiimpool Installer $GREEN $VERSION             ${NC}"
	echo
	echo -e "$YELLOW To run this installer anytime simply type: $GREEN yiimpool            ${NC}"
	echo -e "$YELLOW Donations for continued support of this script are welcomed at:       ${NC}"
	echo "<-------------------------------------|--------------------------------------->"
	echo -e "$YELLOW                     Donate Wallets:                                   ${NC}"
	echo "<-------------------------------------|--------------------------------------->"
	echo -e "$YELLOW Thank you for using Yiimp Install Script $VERSION fork by Afiniel!      ${NC}"
	echo
	echo -e "$YELLOW =>  To run this installer anytime simply type:$GREEN yiimpool         ${NC}"
	echo -e "$YELLOW =>  Do you want to support me? Feel free to use wallets below:        ${NC}"
	echo "<-------------------------------------|--------------------------------------->"
	echo -e "$YELLOW =>  BTC:$GREEN $BTCDON                                   		 ${NC}"
	echo -e "$YELLOW =>  BCH:$GREEN $BCHDON                                   		 ${NC}"
	echo -e "$YELLOW =>  ETH:$GREEN $ETHDON                                   		 ${NC}"
	echo -e "$YELLOW =>  DOGE:$GREEN $DOGEDON                                 		 ${NC}"
	echo -e "$YELLOW =>  LTC:$GREEN $LTCDON                                   		 ${NC}"
	echo "<-------------------------------------|-------------------------------------->"
	exit 0
}

function package_compile_crypto {

	# Installing Package to compile crypto currency
	echo -e "$MAGENTA => Installing needed Package to compile crypto currency <= ${NC}"

	hide_output sudo apt -y install software-properties-common build-essential
	hide_output sudo apt -y install libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev libseccomp-dev libcap-dev libminiupnpc-dev gettext
	hide_output sudo apt -y install libminiupnpc10 libzmq5
	hide_output sudo apt -y install libcanberra-gtk-module libqrencode-dev libzmq3-dev
	hide_output sudo apt -y install libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
	hide_output sudo add-apt-repository -y ppa:bitcoin/bitcoin
	hide_output sudo apt update
	hide_output sudo apt -y install libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
	hide_output sudo apt -y install bison libbison-dev
	hide_output sudo apt -y install libnatpmp-dev libnatpmp1 libqt5waylandclient5 libqt5waylandcompositor5 qtwayland5 systemtap-sdt-dev
	
	hide_output sudo apt-get -y install build-essential libzmq5 \
	libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev \
	libseccomp-dev libcap-dev libminiupnpc-dev gettext libminiupnpc10 libcanberra-gtk-module libqrencode-dev libzmq3-dev \
	libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
	hide_output sudo apt update
	hide_output sudo apt -y upgrade

	hide_output sudo apt -y install libgmp-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev \
	libpgm-dev libhidapi-dev libusb-1.0-0-dev libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev \
	libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev \
	python3 ccache doxygen graphviz default-libmysqlclient-dev libnghttp2-dev librtmp-dev libssh2-1 libssh2-1-dev libldap2-dev libidn11-dev libpsl-dev
}

# Function to check if a package is installed and install it if not
install_if_not_installed() {
  local package="$1"
  if ! command -v "$package" &>/dev/null; then
    echo "Installing $package..."
    apt_install "$package"
  else
    echo "$package is already installed."
  fi
}

function apt_get_quiet {
	DEBIAN_FRONTEND=noninteractive hide_output sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" "$@"
}

function apt_install {
	PACKAGES=$@
	apt_get_quiet install $PACKAGES
}

function apt_update {
	sudo apt-get update
}

function apt_upgrade {
	hide_output sudo apt-get upgrade -y
}

function apt_dist_upgrade {
	hide_output sudo apt-get dist-upgrade -y
}

function apt_autoremove {
	hide_output sudo apt-get autoremove -y
}

function ufw_allow {
	if [ -z "$DISABLE_FIREWALL" ]; then
		sudo ufw allow $1 >/dev/null
	fi
}

function restart_service {
	hide_output sudo service $1 restart
}

## Dialog Functions ##
function message_box {
	dialog --title "$1" --msgbox "$2" 0 0
}

function input_box {
	# input_box "title" "prompt" "defaultvalue" VARIABLE
	# The user's input will be stored in the variable VARIABLE.
	# The exit code from dialog will be stored in VARIABLE_EXITCODE.
	declare -n result=$4
	declare -n result_code=$4_EXITCODE
	result=$(dialog --stdout --title "$1" --inputbox "$2" 0 0 "$3")
	result_code=$?
}

function input_menu {
	# input_menu "title" "prompt" "tag item tag item" VARIABLE
	# The user's input will be stored in the variable VARIABLE.
	# The exit code from dialog will be stored in VARIABLE_EXITCODE.
	declare -n result=$4
	declare -n result_code=$4_EXITCODE
	local IFS=^$'\n'
	result=$(dialog --stdout --title "$1" --menu "$2" 0 0 0 $3)
	result_code=$?
}

function get_publicip_from_web_service {
	# This seems to be the most reliable way to determine the
	# machine's public IP address: asking a very nice web API
	# for how they see us. Thanks go out to icanhazip.com.
	# See: https://major.io/icanhazip-com-faq/
	#
	# Pass '4' or '6' as an argument to this function to specify
	# what type of address to get (IPv4, IPv6).
	curl -$1 --fail --silent --max-time 15 icanhazip.com 2>/dev/null
}

function get_default_privateip {
	# Return the IP address of the network interface connected
	# to the Internet.
	#
	# Pass '4' or '6' as an argument to this function to specify
	# what type of address to get (IPv4, IPv6).
	#
	# We used to use `hostname -I` and then filter for either
	# IPv4 or IPv6 addresses. However if there are multiple
	# network interfaces on the machine, not all may be for
	# reaching the Internet.
	#
	# Instead use `ip route get` which asks the kernel to use
	# the system's routes to select which interface would be
	# used to reach a public address. We'll use 8.8.8.8 as
	# the destination. It happens to be Google Public DNS, but
	# no connection is made. We're just seeing how the box
	# would connect to it. There many be multiple IP addresses
	# assigned to an interface. `ip route get` reports the
	# preferred. That's good enough for us. See issue #121.
	#
	# With IPv6, the best route may be via an interface that
	# only has a link-local address (fe80::*). These addresses
	# are only unique to an interface and so need an explicit
	# interface specification in order to use them with bind().
	# In these cases, we append "%interface" to the address.
	# See the Notes section in the man page for getaddrinfo and
	# https://discourse.mailinabox.email/t/update-broke-mailinabox/34/9.
	#
	# Also see ae67409603c49b7fa73c227449264ddd10aae6a9 and
	# issue #3 for why/how we originally added IPv6.

	target=8.8.8.8

	# For the IPv6 route, use the corresponding IPv6 address
	# of Google Public DNS. Again, it doesn't matter so long
	# as it's an address on the public Internet.
	if [ "$1" == "6" ]; then target=2001:4860:4860::8888; fi

	# Get the route information.
	route=$(ip -$1 -o route get $target | grep -v unreachable)

	# Parse the address out of the route information.
	address=$(echo $route | sed "s/.* src \([^ ]*\).*/\1/")

	if [[ "$1" == "6" && $address == fe80:* ]]; then
		# For IPv6 link-local addresses, parse the interface out
		# of the route information and append it with a '%'.
		interface=$(echo $route | sed "s/.* dev \([^ ]*\).*/\1/")
		address=$address%$interface
	fi

	echo $address

}
