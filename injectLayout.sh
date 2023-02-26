#!/bin/bash
symbols_path=/usr/share/X11/xkb/symbols
rules_path=/usr/share/X11/xkb/rules

main () {
    quick=false

## Interpret input
    interpret_input "$@"

## Ask for Sudo 
    if [ $EUID != 0 ]; then
        sudo "$0" "$@"
        exit $?
    fi

## If quick mode is not true, start prompting
    if [ $quick = false ]; then
        input_prompting
    fi

## Create symlink 
    ln -s $layout "$symbols_path"/$layout

## Add XML to file
    evdev="$rules_path/evdev.xml"
    new_file="$(./xml_printer.awk -v name="$name" -v abbr="$abbr" -v layout="$layout" -v desc="$desc" $evdev)"

## Overwrite file
    echo "$new_file" > "$evdev" && echo "Overwrite success"

## Print success message
    echo "Injection Complete!"
    echo "Restart your machine to detect the layout."
    exit 0
}



## --------------- Functions --------------- ##

## Interpret inputs
function interpret_input {
    num_args=$#

    ## If there are no arguments, return
    if [ $num_args -eq  0  ]; then
        return
    fi

    while true;  do
        case $1 in
            # Meta flags
            -h|--help) help_info; exit 0
            ;;

            # Input flags
            -f|--file) layout="$2"; shift 2
            ;;
            -n|--name) name="$2"; shift 2
            ;;
            -a|--abbreviation) abbr="$2"; shift 2
            ;;

            # Optional Input Flags
            -d|--description) desc="$2"; shift 2
            ;;

            *) break
        esac
    done

    ## Verify all arguments are given
    if [ -z "$name" ] || [ -z "$abbr" ] || [ ! -f "$layout" ]; then
        echo "Please provide all mandatory arguments"
        help_info
        exit 1
    fi

    ## Script is a oneliner
    quick=true
}


## Sequential Prompting
function input_prompting {
    # Layout / Path
    while true 
    do
        read -e -p "Path-to-file: " layout
        if [ -f "$layout" ]; then 
            break
        fi
        echo "Please enter an existing file!"
    done 

    # Name
    while true 
        do
        read -p "Name of Layout: " name
        if [ ! -z "$name" ]; then 
            break 
        fi
        echo "The name must not be empty!"
    done

    # Abbreviation
    while true 
        do
        read -p "Layout Abbreviation: " abbr
        if [ ! -z "$abbr" ]; then 
            break 
        fi
        echo "The abbreviation must not be empty!"
    done

    # Description
    read -p "Description: " desc
}


## Print help information
function help_info {
    help_string="
Basic Usage:
    [1] (Sequential Prompting)  injectLayout.sh
    [2] (One-liner using flags) injectLayout -f file/path -n layout-name -a layout-abbreviation

Options (M: Mandatory, O: Optional):
    [?] -h, --help              Prints information about basic usage and different flag options

    [M] -f, --file              Path to symbols file (layout) that will be symlinked
    [M] -n, --name              Name of the layout, used for identification
    [M] -a, --abbreviation      Abbreviation of the layout, used when dispaying which keyboard is in use on most DE's

    [O] -d, --description       Description of the keyboard. Gives detailed explanation of the keyboards layout

Remarks:
    - Your machine must be restarted after injecting the layout, for the change to have effect.
"
    echo "$help_string"
}

main "$@"
