#!/bin/bash

while getopts 'n:' OPTION; do
    case $OPTION in
        n)
            layout_name="$OPTARG"
            echo "Layout Name: $layout_name"
            ;;
        ?)
            echo "Wrong Usage"
            ;;
    esac
done
shift "$(($OPTIND -1))"

SYMBOLS_PATH=/usr/share/X11/xkb/symbols
RULES_PATH=/usr/share/X11/xkb/rules


