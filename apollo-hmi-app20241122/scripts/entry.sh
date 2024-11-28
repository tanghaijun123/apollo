#
# This file is the entry to prepare for updating software
# called by UI application.
#
# Version 1.0.0
#

#!/bin/bash

DRIVE_PATH="$1"
HOME_DIR="$2"

UPDATE_PACKAGE=`find $DRIVE_PATH -maxdepth 1 -name "update.tar.bz2" | tail -n1`
UPDATE_SCRIPT=$HOME_DIR/update/update.sh

if [ -f "$UPDATE_PACKAGE" ] ; then
        echo "Found package $UPDATE_PACKAGE"
        echo "@1%"
        if [ -f "$HOME_DIR/update.tar.bz2" ] ; then
            rm $HOME_DIR/update.tar.bz2
        fi

        if [ -d "$HOME_DIR/update" ] ; then
            rm -r $HOME_DIR/update
        fi

        ERROR=`cp "$UPDATE_PACKAGE" $HOME_DIR 2>&1`
        if [ "$ERROR" != "" ] ; then
                echo "<$ERROR>"
                exit
        fi
        sleep 2
        echo "@5%"
        cd $HOME_DIR
        ERROR=`tar jxf update.tar.bz2 2>&1`
        if [ "$ERROR" != "" ] ; then
                echo "<$ERROR>"
                exit
        fi
        sleep 2
        echo "@10%"
        echo "$UPDATE_SCRIPT"
        if [ -f "$UPDATE_SCRIPT" ] ; then
                echo "Run update script"
                bash "$UPDATE_SCRIPT" "$HOME_DIR" "$DRIVE_PATH" 2>&1
		echo "Update done" 
	else
		echo "<Error: Can't find update script>"	
	fi
else
	echo "<Error: Can't find update package>"
fi	
