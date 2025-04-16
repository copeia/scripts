#!/bin/bash

## Define script functions ##
#############################

# Print help options as needed 
function help() {
  printf "\nHelp Docs:\n"
  printf "\nSanitize naming of directories and files to remove extra special characters and descriptions. Generally used after torrenting.\n"
  printf "\ntclean -flags (path...) (note: No trailing slash on the path)\n"
  printf "\nFlags:"
  printf "\n  -d directories"
  printf "\n  -f files"
  printf "\n  -x dry-run, list files/directories which would be cleaned"
  printf "\n  -r recursive change"
  printf "\n  -c clean rar files(-f required)\n\n"
}

# Work with files as passed by user input
function files(){

  # Get file list 
  if ${RECURSIVE}
    then
      declare -a OLIST=($(find "${1}" -type f))
    else
      declare -a  OLIST=($(find "${1}" -maxdepth 1 -type f))
  fi

  # Take action on list
  for i in "${OLIST[@]}"
    do
      # When set to clean, check for file type rar and associated extensions
      if ${CLEAN_RARS}
        then 
          if $($(file -b --extension "${OLIST[i]}" | grep -q "rar")  || $(echo "${i}" | grep -q ".sfv\|nfo\|.DS_Store"))
            then
              rm -rf "${OLIST[$i]}" 2>&1 
              REMOVED_FILES+="${OLIST[$i]}\n"
          fi       
      fi

      # When no rar or associated file is found, santize the file name leave the directories in the file path untouched 
      # Get the file name without path
      BASENAME=$(basename "${i}")
      echo "basename: $BASENAME"
      # Get the file path without the file name
      BASEPATH=$(echo "${i}" | sed "s%$BASENAME%%g")
      # Remove specified strings with `sed` to clean or sanitize the file name
      NEW_NAME=$(echo "${BASENAME}" | sed "s%.web%%g;s%.WEB%%g;s%.1080[^.]%%g;s%1080[^.]%%g;s%.h264-[^.]*%%g;")

      if [[ "${BASENAME}" != "${NEW_NAME}" ]]
        then 
          #mv -f "${i}" "${BASEPATH}${NEW_NAME}"
          SANITIZE_OBJECTS+="${i}\n"
        else 
          NOT_SANITIZED+="${i}\n"
      fi 
  done
}

# Work with directories as passed by user input
function directories(){
  # Get directory list 
  if ${RECURSIVE}
    then
      declare -a OLIST=($(find "${1}/" -type d | sed s%//%/%g))
      echo "find dirs recursive"
    else
      declare -a  OLIST=($(find "${1}" -maxdepth 1 -type d | sed s%//%/%g))
  fi

  for i in "${OLIST[@]:1}"
    do
      echo "dir: ${i}"
      sanitize "${i}"
  done
}

## Script Entry ##
##################

USER_INPUT_FLAGS="${1}"
USER_INPUT_DIR="${2}"

# Set default vars #
DRY_RUN=false
RECURSIVE=false
CLEAN_RARS=false

# Get flags as passed by the user wehen running the script #

# If h is passed at all, or the input is empty or there is only a -
if [[ ("$USER_INPUT_FLAGS" == *"h"*) || ( -z "$USER_INPUT_FLAGS") || ("$USER_INPUT_FLAGS" == "-") ]]
  then 
    # Call the help function
    help
fi 

# If -x is passed set dry_run var
if [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"x"*) ]]
  then
    DRY_RUN=true
fi 

# If -r is passed set recursive var
if [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"r"*) ]]
  then
    RECURSIVE=true
    echo "recursive true"
fi 

# If -c is passed set clean true 
if [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"c"*) && ("$USER_INPUT_FLAGS" == *"f"*) ]]
  then
    CLEAN_RARS=true
    echo "Cleanings rars"
fi

# If only files and no directories
if [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"f"*) && ("$USER_INPUT_FLAGS" != *"d"*) ]]
  then
    echo "files only"
    files "${USER_INPUT_DIR}"
# If only directories and no files
elif [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"d"*) && ("$USER_INPUT_FLAGS" != *"f"*) ]]
  then
    echo "directories only"
    directories "${USER_INPUT_DIR}"
elif [[ ("$USER_INPUT_FLAGS" == "-"*) && ("$USER_INPUT_FLAGS" == *"d"*) && ("$USER_INPUT_FLAGS" = *"f"*) ]]
  then 
    echo "both"
    directories "${USER_INPUT_DIR}"
    files "${USER_INPUT_DIR}"
fi

# Results #

printf "Sanitized:\n${SANITIZE_OBJECTS}" 
printf "Not Sanitized:\n${NOT_SANITIZED}" 
printf "Removed:\n${REMOVED_FILES}"