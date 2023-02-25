#!/bin/bash

## Print help information
function help_info {
    echo "Help Comming!"
}


### Different Input Methods ###
## Sequential Prompting
function input_prompting {
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
}

## Oneliner with flags.
function input_oneliner {
    COUNTER=1
    while getops f:n:a:d: OPTION; do
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
            d) # Description
                DESC="${args[$COUNTER]}"
                let COUNTER++
                ;;
            ?)
                echo "Wrong Usage"
                help_info
                exit 1
                ;;
        esac
    done
    echo "OPTIND: $OPTIND"
    shift "$(($OPTIND -1))"

    echo "Layout: $LAYOUT"
    echo "Name: $NAME"
    echo "Abbr: $ABBR"
    echo "Desc: $DESC"

    ## Verify all arguments are given ##
    if [ -z "$NAME" ] || [ -z "$ABBR" ] || [ ! -f "$LAYOUT" ]; then
        echo "Please provide all arguments"
        help_info
        exit 1
    fi
}




### ---------- Start of code ---------- ###

SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules

## Ask for Sudo 
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi


## Find out what first argument is and act accordingly
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help_info
    exit 0

elif [ "$1" == "-q" ] || [ "$1" == "--quick" ]; then
    input_oneliner

elif [ -z "$1" ]; then
    input_prompting

else
    help_info
    exit 1
fi

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
exit 0
