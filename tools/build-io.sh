#!/bin/bash

# Copyright (C) 2015 The InfinitiveOS Project

#NOTE. 
# This script is intended to be written in this way 
# Don't try to modify this on your own cause you may end by messing all the script up 
# If you want to add features or if you are having issues with the script just send me a message: 
# On XDA: nilac8991
# Or on email: nilac8991@gmail.com
# I wish you good work and we hope that the script will help you with the ROM building.


# We don't allow scrollback buffer
echo -e '\0033\0143'
clear

# Obtain intial time of script startup
res1=$(date +%s.%N)

# ALL HAIL GREEN
tput setaf 2

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


function IOMAINSPLASH () {
	tput bold
	tput setaf 2
	echo -e "   .___        _____.__       .__  __  .__             ________    _________"
	echo -e "   |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/"
	echo -e "   |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \ "
	echo -e "   |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
	echo -e "   |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  /"
	echo -e "           \/              \/                       \/        \/          \/"
	echo -e "                                                             Mode:  $mode "
	tput sgr0
	tput setaf 2
}

function SYNCREPO () {

	echo -e "  Would you like us to upgrade and check for dependencies to avoid errors while building? \n"
	echo -e "  (yes/no) \c"
	tput sgr0
	tput setaf 2
	read askDependencies
	if [[ $askDependencies = "yes" || $askDependencies = "Yes" || $askDependencies = "YES" ]]; then
		echo -e ""
		echo -e "   > Running the dependencies script"
		echo -e ""
		x-terminal-emulator -e ./dependencies.sh
		echo -e ""
	echo -e "  Press any key to continue after the upgrade is completed "
	echo -e ""
	read blank
	fi
	echo -e "Going now to repo sync the sources..."
	sleep 2
	echo -e "Choose the numbers of cores for the sync, if you don't know just press enter"
	read repocores
	if [[ -n $repocores ]]; then
	repo sync -j$repocores
	else
	repo sync
	fi
	cd .repo/local_manifests
	if [ -f "roomservice.xml" ]; then
	rm -f roomservice.xml
	fi
	cd ..
	cd ..
}

function REPOINIT () {
	clear
 	IOMAINSPLASH
 	sleep 1
 	tput setaf 3
 	echo -e ""
 	echo -e "You choosed this option because the repo is not initialized yet"
 	echo -e "If you changed your mind and the script is really in the InfinitiveOS repo directory"
 	echo -e "Write exit, otherwise write no. and you will be prompted to the main menu"
 	echo -e ""
 	read askprerepoinit
 	if [[ $askprerepoinit = "exit" || $askprerepoinit = "Exit" || $askprerepoinit = "EXIT" ]]; then
 		clear
 		sleep 2
 		echo -e "Loading main menu..."
 	else
 		clear
 		echo -e ">> Initializing Pre Repo stuff.."
 			tput setaf 2
			mkdir -p ~/bin
			PATH=~/bin:$PATH
			if [ -f "repo" ]; then
				tput setaf 3
				echo -e "Skipping cause repo is already initialized.."

			else
				tput setaf 2
				curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
				chmod a+x ~/bin/repo
				echo -e ""
				sleep 1
			fi
		tput setaf 3
		echo -e "Insert here the name of the directory which will be used for the InfinitiveOS Sources"
		tput setaf 2
		read infinitivename
		tput setaf 3
		mkdir -p $infinitivename
		echo -e ">> Going to repo init the sources in the $infinitivename directory"
		cd $infinitivename
		sleep 2
		tput setaf 2
		repo init -u https://github.com/InfinitiveOS/platform_manifest -b io-1.0
		echo -e "Repo initialization done"
		echo -e ""
		sleep 2
		clear
	#Copy the script into the new generated source folder
	cd ..
	cp build-io.sh $infinitivename
	tput setaf 3
	echo -e "Github part!"
	sleep 2
	echo -e "Please enter your email for Git config : \c"
	tput setaf 2
	read gitemail
	git config --global user.email $gitemail
	sleep 2
	tput setaf 3
	echo -e "Please enter your name for Git config : \c"
	tput setaf 2
	read gituser
	git config --global user.name $gituser
	tput setaf 3
	echo -e ""
	echo -e "Github part done"
	sleep 2
	clear
 	echo -e "Do you want to repo sync now and install missing dependencies?"
 	echo -e "Insert 1 or 0"
 	sleep 1
 	tput setaf 2
 	read askrepodep
 	if [[ $askrepodep = "1" ]]; then
 		tput setaf 3
 		echo -e ">> Going to repo sync now..."
 		echo -e "Remember this step will take some time according to your internet connection"
 		sleep 3
 		clear
 		SYNCREPO
	fi
	tput setaf 3
	echo -e "Done ! The Repo is now initialized, but remember to repo sync and to install missing dependencies !"
	echo -e "Script copied to the $infinitivename directory"
	sleep 3
fi
}

function SHELLINTARGET () {
	IOMAINSPLASH
		echo -e ""
		echo -e " NOTE: To not cause troubles, all functions at start are disabled by default. "
		echo -e " 	if the shell is in same directory as the InfinitiveOS ROM sources press 12"
		echo -e " 	Else press 100 to initialize the InfinitiveOS ROM sources"
		echo -e ""
	echo -e "  Enter choice : \c"
	read shellintargetmenu
	if [[ $shellintargetmenu = "12" || $shellintargetmenu = "100" ]]; then
	if ( test $shellintargetmenu = "12"); then
	echo -e "Starting main menu..."
	sleep 2
	clear
	else
	REPOINIT
	fi
	else
	clear
	echo -e "Wrong choice, try again!"
	echo -e ""
	SHELLINTARGET
	fi
}

SHELLINTARGET

function CURRENTCONFIG () {
	echo -e " "
	echo -e "  NOTE : We are using Binary inputs"
	echo -e "  1 for Yes "
	echo -e "  0 for No "
	echo -e ""
	tput bold
	tput setaf 6
	echo -e "============================================================"
	echo -e ""
	echo -e " BUILD_ENV_SETUP = $BUILD_ENV_SETUP"
	echo -e " CHERRYPICK = $CHERRYPICK"
	echo -e ""
	echo -e " MAKE_CLEAN = $MAKE_CLEAN"
	echo -e " MAKE_DIRTY = $MAKE_DIRTY"
	#echo -e " MAKE_INSTALLCLEAN = $MAKE_INSTALLCLEAN"
	echo -e " REPO_SYNC_BEFORE_BUILD = $REPO_SYNC_BEFORE_BUILD"
	echo -e ""
	echo -e "============================================================"
	echo -e ""
	tput sgr0
	tput setaf 2
	if [[ $MAKE_CLEAN != "0" || $REPO_SYNC_BEFORE_BUILD != "1" || $CHERRYPICK != "0" || $MAKE_DIRTY != "0" ]]; then
		echo -e ""
		mode=Custom
	else
		mode=Default
	fi
}

function DISPLAYMAINMENU() {
	if [[ -n $TARGET_PRODUCT ]]; then
		echo -e "  *************************************"
		echo -e "	  TARGET_PRODUCT: $TARGET_PRODUCT   "
		echo -e "  *************************************"
	fi
	CURRENTCONFIG
	echo -e "  1. Sync InfinitiveOS Repo"
	echo -e "  2. Configure Build parameters"
	echo -e "  2a. Reset All configurations"
		echo -e "  3. Set-up current Target device"
		if [[ -n $TARGET_PRODUCT ]]; then
		echo -e "  4. Configure Cherry-pick script"
		echo -e "  5. Build InfinitiveOS for $TARGET_PRODUCT"
	fi
	echo -e "  6. Exit"
	echo -e ""
	echo -e "Enter your choice \n"
	read mainMenuChoice
	PROCESSMENU $mainMenuChoice
}

function PROCESSMENU () {
	case $mainMenuChoice in
		1) SYNCREPO ;;
		2) CONFIGUREBUILD ;;
		2a) DEFCONFIG ;;
		3) DEVICETARGET;;
		4) CHERRYPICK;;
		5) BUILD ;;
		6) exit ;;
		7) export BUILD_ENV_SETUP=0 ;;
		8) export BUILD_ENV_SETUP=1 ;;
		99) DEFCONFIG ;; #Reset to default settings
		*) echo "  Invalid Option! ERROR!" ;;
	esac
	echo -e " Press any key to continue..."
	read blank
	clear
}

function CONFIGUREBUILD () {
	clear
	IOMAINSPLASH
	tput setaf 3
	echo -e "Begining to edit the default build options."
	echo -e "      "
	echo -e "     | Submit values in binary bits"
	echo -e "     | 1 for Yes, and 0 for No"
	echo -e ""
	echo -e "Make clean before starting the build?"
	echo -e "	Make clean will delete all the containing files contained in the OUT folder, in order to make a clean build : \c"
	tput setaf 2
	read MAKE_CLEAN
	if [[ "$MAKE_CLEAN" == 0 || "$MAKE_CLEAN" == 1 ]]; then
		echo -e ""
	else
	tput setaf 3
	echo ""
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGUREBUILD
	fi

	#tput setaf 3
	#if (test $MAKE_CLEAN = "1"); then
	#	echo -e "Skipping Make InstallClean because Make clean is activated so it's unuseful"
	#else
	#echo -e "Make InstallClean before starting the build?"
	#echo -e "	Make Install Clean will delete just the intermediates stuff like Apps intermediates in order to build them again from scratch : \c"
	#tput setaf 2
	#read #MAKE_INSTALLCLEAN
	#if [[ $MAKE_INSTALLCLEAN == 0 || $MAKE_INSTALLCLEAN == 1 ]]; then
	#	echo -e ""
	#else
	#echo -e ""
	#tput setaf 3
	#echo -e "ERROR! Wrong parameters passed. Reconfigure"
	#CONFIGUREBUILD
	#fi
#fi
	tput setaf 3
	if (test $MAKE_CLEAN = "1"); then
		echo -e "Skipping Make dirty because Make clean is activated so it's unuseful"
		echo -e ""
	else
	echo -e "Make Dirty before starting the build?"
	echo -e "	Make Dirty will delete the previous build zip, build.prop,changelog and md5sum in order to regenerate them : \c"
	tput setaf 2
	read MAKE_DIRTY
	if [[ $MAKE_DIRTY == 0 || $MAKE_DIRTY == 1 ]]; then
		echo -e ""
	else
	tput setaf 3
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGUREBUILD
	fi
fi

	tput setaf 3
	echo -e "Repo sync before starting the build?"
	echo -e "	Repo sync will automatically be launched before the build starts : \c"
	tput setaf 2
	read REPO_SYNC_BEFORE_BUILD
	if [[ $REPO_SYNC_BEFORE_BUILD == 0 || $REPO_SYNC_BEFORE_BUILD == 1 ]]; then
		if (test $REPO_SYNC_BEFORE_BUILD = "1"); then
				cd .repo/local_manifests
				if [ -f "roomservice.xml" ]; then
				rm -f roomservice.xml
				fi
				cd ..
				cd ..
		echo -e ""
		fi
	tput setaf 3
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGUREBUILD
	fi

	tput setaf 3
		if [ -f "cherry_$TARGET_PRODUCT.sh" ]; then
		echo -e ""
		echo -e "Use cherry-pick script before starting the build for the $TARGET_PRODUCT device? : \c"
		tput setaf 2
		read CHERRYPICK
			if [[ $CHERRYPICK == 0 || $CHERRYPICK == 1 ]]; then
			echo -e ""
			tput setaf 3
			else
			echo -e " ERROR! Wrong parameters passed. Reconfigure"
			CONFIGUREBUILD
			fi
		tput setaf 3
		else
		echo -e "Sorry but no cherry_$TARGET_PRODUCT.sh was found, try maybe to reconfigure the cherry script and come back here after"
		fi

}

function DEVICETARGET () {
	clear
	tput sgr0
	tput setaf 4
	echo -e "Checking if the build environment is initialized.."
	if (test $BUILD_ENV_SETUP = "1"); then
	echo -e "Build environment already initialized skipping..."
	else
	BUILD_ENV_SETUP=1
	source build/./envsetup.sh
	fi
	clear
	IOMAINSPLASH
	tput setaf 4
	echo -e "Official Devices"
	echo -e ""
	echo -e ""
	echo -e "Samsung Galaxy S+ (ariesve)"
	echo -e "Samsung Galaxy Grand Duos (i9082)"
	echo -e "Samsung Galaxy S5 Mini (kmini3g)"
	echo -e "Samsung Galaxy S3 Neo (s3ve3g)"
	echo -e "Motorola Moto G 2014 (titan)"
	echo -e "Motorola Moto G (falcon)"
	echo -e "Motorola Moto E (condor)"
	echo -e "Sony Xperia L (taoshan)"
	echo -e "Sony Xperia Z (yuga)"
	echo -e "Sony Xperia Z2 (honami)"
	echo -e "Sony Xperia Z3 (leo)"
	echo -e "Xiaomi Redmi 1S (armani)"
	echo -e "Xiaomi Mi3 (cancro)"
	echo -e "Yu Yureka (tomato)"
	echo -e ""
	echo -e ""
	sleep 1
	echo -e "Insert the codename of the device which you will gonna build for:"
	tput setaf 2
	read TARGET_PRODUCT
	if [[ $TARGET_PRODUCT = "ariesve" || $TARGET_PRODUCT = "i9082" || $TARGET_PRODUCT = "kmini3g" || $TARGET_PRODUCT = "s3ve3g" || $TARGET_PRODUCT = "titan" || $TARGET_PRODUCT = "falcon" || $TARGET_PRODUCT = "condor" || $TARGET_PRODUCT = "taoshan" || $TARGET_PRODUCT = "yuga" || $TARGET_PRODUCT = "honami" || $TARGET_PRODUCT = "leo" || $TARGET_PRODUCT = "armani" || $TARGET_PRODUCT = "cancro" || $TARGET_PRODUCT = "tomato" ]]; then
	tput setaf 4
	echo -e "Going to make Breakfast for the $TARGET_PRODUCT device"
	breakfast $TARGET_PRODUCT
	clear
	echo -e "Breakfast completed, ROM build is set now for the $TARGET_PRODUCT device"
else
	tput setaf 4
	echo -e ">>	Device is not an official one, going to switch to unofficial"
	sleep 3
	echo -e ""
	echo -e "Is your local_manifest ready? \c"
	tput setaf 2
	read asklocal_manifest
		if [[ $asklocal_manifest = "no" || $asklocal_manifest = "No" || $asklocal_manifest = "NO" ]]; then
		echo -e ""
		cd .repo
		mkdir -p local_manifests
		cd local_manifests
		nano local_manifest.xml
		cd ..
		cd ..
		tput setaf 4
		echo -e "Press enter to continue"
		read blank
		echo -e ""
		echo -e "local_mainfest changed! Going to repo sync..."
		repo sync
		clear
		fi
		echo -e ""
		echo -e "Insert the codename of the unofficial device which you will gonna build for"
		tput setaf 2
		read TARGET_PRODUCT
		tput setaf 4
		echo -e "Going to make Breakfast for the $TARGET_PRODUCT device"
		breakfast $TARGET_PRODUCT
		tput setaf 4
		clear
		echo -e "Breakfast completed, ROM build is set now for the $TARGET_PRODUCT device"
fi
	tput sgr0
}


function CHERRYPICK() {
	clear
	IOMAINSPLASH
	tput setaf bold
	tput setaf 3
	echo -e "Introduction:"
	sleep 2
	tput setaf 2
	echo -e ""
	echo -e "Basically this script will be made separately for each device"
	echo -e "And this script will be used for the developers who will need to cherry pick some propietary stuff for the device in order to compile the ROM"
	echo -e "To don't repeat this every time, it's better to generate a script and run it every time you make a new build for the device"
	echo -e "I think you already know how cherry-pick works so i won't stay here explain to you how to do that :)"
	echo -e "You are currently building for $TARGET_PRODUCT"
	echo -e ""
	tput setaf 3
	echo -e "Press enter when you are ready"
	read blank
	nano cherry_$TARGET_PRODUCT.sh
}

function BUILD () {
	clear
	IOMAINSPLASH
	sleep 2
	tput setaf 4
	echo -e ""
	echo -e "Currently building for $TARGET_PRODUCT"
	sleep 2
	echo -e "Continue with this device?"
	tput setaf 2
	read devicecheck
	if [[ $devicecheck = "no" || $devicecheck = "No" || $devicecheck = "NO" ]]; then
	DEVICETARGET
else
	tput setaf 4
	echo -e " >> Applying selected build configurations"
	echo -e ""
	if ( test $MAKE_CLEAN = "1"); then
	echo -e "		>> Going to clean the entire OUT directory"
		make clean
		echo -e ""
	fi
	if ( test $MAKE_DIRTY = "1"); then
	echo -e "		>> Going to delete old build zip,build.prop,md5sum and changelog"
		make dirty
		echo -e ""
	fi
	if ( test $REPO_SYNC_BEFORE_BUILD = "1"); then
	echo -e "		>> Going to repo sync now, choose the numbers of cores: (If you don't know just press enter)"
	read repocores
	if [[ -n $repocores ]]; then
		repo sync -j$repocores
		echo -e ""
	else
	repo sync
	cd .repo/local_manifests
	if [ -f "roomservice.xml" ]; then
	rm -f roomservice.xml
	fi
	cd ..
	cd ..
	echo -e ""
	echo -e ""
fi
fi

	if (test $CHERRYPICK = "1"); then
	echo -e "	>> Going to cherry pick some stuff for the $TARGET_PRODUCT device"
	chmod +x cherry_$TARGET_PRODUCT.sh
	tput sgr0
	sleep 2
	./cherry_$TARGET_PRODUCT.sh
	tput setaf 4
	echo -e "		>> Cherry pick done, proceed now with the build"
	sleep 2
fi
	clear
	tput setaf 4
	echo -e ""
	echo -e "Choose the number of CPU cores to use during the compilation (If you don't know just press enter): \c"
	read buildcores
	if [[ -n $buildcores ]]; then
		sleep 2
		clear
		echo -e "	>> Build started !"
		echo -e "			Just sit down, relax take a cup of tea and some biscuits cause this is gonna take some time"
		sleep 4
		tput sgr0
		make otapackage -j$buildcores
	else
		sleep 2
		clear
		echo -e "	>> Build started !"
		echo -e "			Just sit down, relax take a cup of tea and some biscuits cause this is gonna take some time"
		sleep 4
		tput sgr0
		make otapackage
	fi
	echo -e ""
	echo -e ""
	echo -e "Build was successfully completed, congrats!"
	echo -e "You can find your build in out/target/product/$TARGET_PRODUCT"
	echo -e ""
	echo -e ""
fi
}

function DEFCONFIG {
	# Red
	tput setaf 1
	tput bold

	echo -e "  Loading defaults..\n"

	mode=Default

	tput sgr0
	tput setaf 1

	#Option values
	MAKE_CLEAN=0
	#MAKE_INSTALLCLEAN=0
	MAKE_DIRTY=0
	REPO_SYNC_BEFORE_BUILD=1
	#makeApp=0
	BUILD_ENV_SETUP=0
	CHERRYPICK=0

	#Restore Green
	tput sgr0
	tput setaf 2
	return
}

#Load default configurations
DEFCONFIG

while [[ true ]]; do
	IOMAINSPLASH
	DISPLAYMAINMENU
done

$normal
