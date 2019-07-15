#!/bin/bash

# Colourise the output
RED='\033[0;31m'        # Red
GRE='\033[0;32m'        # Green
YEL='\033[1;33m'        # Yellow
NCL='\033[0m'           # No Color

phpcsxx(){
        #phpcs '--standard=Drupal' $entry
        cmd="phpcs --standard=Drupal $entry"

        eval $cmd
        Extport=$?
        if [[ "$Extport" == 0 ]]
        then
                echo -e "${GRE}No Error: phpcs --standard=Drupal $entry${NCL}"  
        else
                echo -e "${RED}-----------------------------------------------------------------------------------------------------------------------------------------------------${NCL}" 
                echo -e "${NCL}^ Please Fix above ${RED}Errors${NCL}: $entry ^" 
                echo -e "${RED}-----------------------------------------------------------------------------------------------------------------------------------------------------${NCL}" 
        fi
}
walk() {
        local indent="${2:-0}"
        printf "\n${YEL}%s${NCL}\n\n" "$1 (Directory)"
        # If the entry is a file do some operations
        for entry in "$1"/*; do [[ -f "$entry" ]] && phpcsxx "$entry"; done
        
        #for entry in "$1"/*; do phpcsxx "$entry" ; done
        
        # If the entry is a directory call walk() == create recursion
        for entry in "$1"/*; do [[ -d "$entry" ]] && walk "$entry" $((indent+4)); done
}

# If the path is empty use the current, otherwise convert relative to absolute; Exec walk()
[[ -z "${1}" ]] && ABS_PATH="${PWD}" || cd "${1}" && ABS_PATH="${PWD}"
walk "${ABS_PATH}"      
echo                    
