#!/bin/bash
SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules

## Ask for Sudo 
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

## Get variables
read -e -p "Path-to-file: " LAYOUT
read -p "Name of Layout: " NAME
read -p "Layout Abbreviation: " ABBR
read -p "Description: " DESC

## Verify all arguments are given 
if [ -z "$NAME" ] || [ -z "$ABBR" ] || [ -z "$LAYOUT" ] || [ -z "$DESC" ]; then
    echo "Please make sure all arguments are not null and valid"
    exit 1
fi

## Create symlink 
ln -s $LAYOUT "$SYMBOLS_PATH"/$LAYOUT

## Add XML to file
EVDEV="$RULES_PATH/evdev.xml"
NEW_FILE="$(./xml_printer.awk -v NAME="$NAME" -v ABBR="$ABBR" -v LAYOUT="$LAYOUT" -v DESC="$DESC" $EVDEV)"

## Overwrite file
echo "$NEW_FILE" > $EVDEV
