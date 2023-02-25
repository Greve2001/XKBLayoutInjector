#!/bin/bash
SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules

## TODO
# - Need to make description flag


## Ask for Sudo ##
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

## Get arguments ##
COUNTER=0
while getopts f:n:a: OPTION; do
    args+=("$OPTARG")
    case $OPTION in
        f) # Layout File Name
            LAYOUT="${args[$COUNTER]}"
            let COUNTER++
            ;;
        n) # Layout Name
            NAME="${args[$COUNTER]}"
            let COUNTER++
            ;;
        a) # Layout Abbreviation
            ABBR="${args[$COUNTER]}"
            let COUNTER++
            ;;
        ?)
            echo "Wrong Usage"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

## Verify all arguments are given ##
if [ -z "$NAME" ] || [ -z "$ABBR" ] || [ -z "$PATH" ]; then
    echo "Please provide all arguments"
    exit 1
fi

ln -s $LAYOUT "$SYMBOLS_PATH"/$LAYOUT

EVDEV="$RULES_PATH/evdev.xml"
NEW_FILE="$(./xml_printer.awk -v NAME=$NAME -v ABBR=$ABBR -v LAYOUT=$LAYOUT $EVDEV)"

echo "$NEW_FILE" > $EVDEV
