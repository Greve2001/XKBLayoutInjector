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

# ln -s $LAYOUT "$SYMBOLS_PATH"/$LAYOUT



XML_STRING="
<layoutList>
  <layout>
    <configItem>
      <name>$LAYOUT</name>
      <shortDescription>$ABBR</shortDescription>
      <description>$NAME</description>
      <countryList>			<!-- Can be removed??? -->
        <iso3166Id>DK</iso3166Id>
      </countryList>
      <languageList>		<!-- Can be removed??? -->
        <iso639Id>dan</iso639Id>
      </languageList>
    </configItem>
    <variantList>
      <variant>
        <configItem>
          <name>$NAME</name>
          <description>Insert Description</description>
        </configItem>
      </variant>
    </variantList>
  </layout>
"
  

