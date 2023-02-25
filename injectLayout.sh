#!/bin/bash
SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules

## Ask for Sudo 
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

## Get variables and make sure they are valid
# Layout / Path
while true 
do
    read -e -p "Path-to-file: " LAYOUT
    if [ -f "$LAYOUT" ]; then 
        break
    fi
    echo "Please enter an existing file!"
done 

# Name
while true 
    do
    read -p "Name of Layout: " NAME
    if [ ! -z "$NAME" ]; then 
        break 
    fi
    echo "The name must not be empty!"
done

# Abbreviation
while true 
    do
    read -p "Layout Abbreviation: " ABBR
    if [ ! -z "$ABBR" ]; then 
        break 
    fi
    echo "The abbrivation must not be empty!"
done

# Description
read -p "Description: " DESC


## Create symlink 
ln -s $LAYOUT "$SYMBOLS_PATH"/$LAYOUT || exit 1

## Add XML to file
EVDEV="$RULES_PATH/evdev.xml"
NEW_FILE="$(./xml_printer.awk -v NAME="$NAME" -v ABBR="$ABBR" -v LAYOUT="$LAYOUT" -v DESC="$DESC" $EVDEV)"

## Overwrite file
echo "$NEW_FILE" > $EVDEV

## Print success message
echo "Injection Complete!"
echo "Restart your machine to detect the layout."
