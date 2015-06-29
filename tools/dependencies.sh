#!/bin/bash

# Copyright (C) 2015 The InfinitiveOS Project

#NOTE. 
# This script is intended to be written in this way 
# Don't try to modify this on your own cause you may end by messing all the script up 
# If you want to add features or if you are having issues with the script just send me a message: 
# On XDA: nilac8991
# Or on email: nilac8991@gmail.com
# I wish you good work and we hope that the script will help you with the ROM building.

# Our Rainbow
red='tput setaf 1'              # red
green='tput setaf 2'            # green
yellow='tput setaf 3'           # yellow
blue='tput setaf 4'             # blue
violet='tput setaf 5'           # violet
cyan='tput setaf 6'             # cyan
white='tput setaf 7'            # white
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Bold red
bldgrn=${txtbld}$(tput setaf 2) # Bold green
bldblu=${txtbld}$(tput setaf 4) # Bold blue
bldcya=${txtbld}$(tput setaf 6) # Bold cyan
normal='tput sgr0'

tput setaf 1
echo "Checking and installing Post-Dependencies for the build environment"
echo "This step is automatically skipped if there already installed"

	tput setaf 2
	echo "Insert your password:"

		sudo apt-get update 
		sudo apt-get install openjdk-7-jdk -y
		sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-6-jre openjdk-6-jdk pngcrush schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline-gplv2-dev gcc-multilib -y
		sleep 2
tput setaf 1
echo -e ""
echo "Making a quick upgrate for system files"
echo -e ""
tput setaf 2
sudo apt-get upgrade

exit
