#!/bin/bash
########################################################################################################
# Simple script that will rename files. 
# Takes an absolute path as input, and looks for specific string in the file names. Will not traverse
# up the specified path. It will keep a log of the last run in the script's directory.
#
# Author: jgezau
# Version 1.0
# 
# Usage:
# $ ./rename.sh "/full/path/to/files"
########################################################################################################

# Variables
path=$1
strToSearch="The Beverly Hillbillies"
strToMatch="Hillbillies-"
replaceChar="1x"
logFile="log.txt"

abs=$(echo "$path" | cut -c1 )
thisDir=$(pwd)

if [[ $# -eq 0 ]]; then
	echo -e "** Provide an absolute path **"
	exit 1
elif [[ ! -d $path ]]; then
	echo "** Directory does not exists **"
	exit 1
elif [[ $abs != "/" ]]; then
	echo "** Not an absolute path **"
	exit 1
else
	# Change directory
	cd "$path"
	
	count=0
	echo -e "*** $(date) ***\n$path" >> "$thisDir/$logFile"
	
	old_IFS=$IFS	# Save the field separator
	IFS=$'\n'			# New field separator, the end of line
	
	# Check if log file was created
	if [[ ! -f "$thisDir/$logFile" ]]; then
		echo "** Could not create Log File **"
		echo "Do you wish to continue w/o Log File? (y/n)"
		read cont
		
		if [[ "$cont" == "y" ]]; then
			continue > /dev/null 2>&1
		else
			exit 0
		fi
	fi
	
	# Searching for files matching specific text
	for oldFName in $(find . -type f -maxdepth 1 -exec basename {} \; | grep "$strToSearch"); do
		newFName=$(echo "$oldFName" | awk -F"$strToMatch" '{if (NF>1) {print $NF}}' | sed 's:^ ::') 
		
		# 'strToMatch' will be replaced with 'TBH'
		#newFName=$(echo "$oldFName" | sed 's:'$strToMatch':TBH:') 
		
		if [[ "$replaceChar" != "" ]]; then
			newFName=$(echo "$newFName" | sed 's:'$replaceChar':S01E:' )
		fi
		
		echo "Renaming '$oldFName' to '$newFName'"
		
		# Logging
		echo mv "$oldFName" "$newFName" >> "$thisDir/$logFile"

		# Rename files
		# Uncomment 
		#mv "$oldFName" "$newFName"
		
		(( ++count ))
	done

	IFS=$old_IFS		# Restore default field separator
	
	echo "Renamed $count files"

	# Go back to previous directory
	cd -
fi
