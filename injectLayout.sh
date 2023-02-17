#!/bin/bash

# Get arguments
COUNTER=0
while getopts n:a: OPTION; do
    args+=("$OPTARG")
    case $OPTION in
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

# Verify all arguments are given
if [ -z "$NAME" ] || [ -z "$ABBR" ]; then
    echo "Please provide all arguments"
    exit 1
fi

echo "Layout Name: $NAME"
echo "Layout Abbreviation: $ABBR"

SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules


