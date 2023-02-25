# XKB Layout Injector
This repository contains a bash script that can be used to link customized xkb layouts (aka. symbol files).    
The user using this repository needs to create their own layout file. (This can be done copying one from /usr/share/X11/xkb/symbols)    
The way the script works is that it inserts/injects a string block of XML into the evdev.xml file in /usr/share/X11/xkb/rules. The scripts also create a symlink from the custom layout to the symbols folder.

## Why?
I had previously made a custom layout for programming. I had configure the files manually, which took me quite some time to figure out. A few weeks later, I updated my system packages, and I guess the files for XKB got overwritten. So because im somewhat lazy, I decied to make a script for it.    
I hope someone else will also get some use from this.    

## Usage
Run below command, and follow terminal prompts.
```
./injectLayout.sh
```
OBS! After running the script you will need to restart your machine for the change to take place.

## Remarks
- The script does not support injecting more than one variant of the layout. Therefor you will for now need to keeps it to one variant per layout.
