#!/bin/bash
########################################################################################################
# Simple script that will rename files. 
# Takes an absolute path as input, and looks for specific string in the file names. Will not traverse
# up the specified path. It will keep a log of the last run in the script's directory.
#
# Author: jgezau
# Version 0.1
# 
# Usage:
# $ ./rename.sh "/full/path/to/files"
########################################################################################################

# Variables
path=$1
strToSearch="[Tt]itle [Oo]f [Ss]how - "
strToMatch=" -"
oldFName="oldFName.txt"
newFName="newFName.txt"

abs=$(echo "$path" | cut -c1 )
thisDir=$(pwd)

if [[ $# -eq 0 ]]; then
	echo -e "** Provide an absolute path **"
elif [[ ! -d $path ]]; then
	echo "** Directory does not exists **"
elif [[ $abs != "/" ]]; then
	echo "** Not an absolute path **"
else
	# Change directory
	cd "$path"
	
	# Creating files with old and new fileNames
	find . -type f -maxdepth 1 -exec basename {} \; | grep "$strToSearch" > "$oldFName"
	find . -type f -maxdepth 1 | grep "$strToSearch" | awk -F"$strToMatch" '{if (NF>1) {print $NF}}' | sed 's:^ ::' > "$newFName"
	
	cp "$oldFName" "$newFName" "$thisDir"
	
	filesCount=$(cat "$oldFName" | wc -l)
	echo "Renaming $filesCount files"

	old_IFS=$IFS		# Save the field separator
	IFS=$'\n'			# New field separator, the end of line

	# Saving file names into arrays
	count=0
	for line in $(cat $oldFName); do
		oldFNameArr[$count]=$line
		(( count++ ))
	done
	count=0
	for line in $(cat $newFName); do
		newFNameArr[$count]=$line
		(( count++ ))
	done

	IFS=$old_IFS		# Restore default field separator

	# Renaming Files
	for (( i = 0; i < $count ; i++ )); do
		mv "${oldFNameArr[$i]}" "${newFNameArr[$i]}"
	done

	# Remove helper files
	rm "$oldFName" "$newFName"

	# Go back to previous directory
	cd -
fi

# ./rename.sh "/Users/esausilva/Downloads/Audio/Radio Theatre/Adventures In Odyssey/_Misc/test/500th Episode"
