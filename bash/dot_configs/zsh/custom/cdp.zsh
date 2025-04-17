#!/bin/zsh

# Allow user to use the shortcut `cdp ${project_name}` to switch into any given git project directory.
# Please set the correct ORG_LIST and project_dir variables. This script assumes you have git authenticated locally and have the tool 'gh' installed. 

# Ex: 
    # cdp sbdeco

function cdp() {
  # Get the user input and set to a var. (This is done to allow for easier string expansion later in the script)
  USER_INPUT="${1}"

  # Define a space delimited list of orgs
  declare -a ORG_LIST=("SimpleBet")

  # Define a project base directory for your git repos. (This directory should already exist)
  PROJECT_DIR="/Users/$(whoami)/projects"

  # Get a listing of projects found within the project directory mentioned above; return directory name/s only. 
  PROJECT_LIST=$(ls -d ${PROJECT_DIR}/*/ | awk -F/ '{print $5}')

  # Verify gh is installed so the github portions of this script work
  if ( ! which gh > /dev/null 2>&1 )
    then
      printf "Github cli tool \033[0;33mgh\033[0m missing, please run \033[0;32mbrew install gh\033[0m before using this script"
  fi

  # Verify user input was given, if not, change into the root ${PROJECT_DIR}
  if [[ ! -z ${USER_INPUT} ]]
    then
      # Try to find a match for a project based on the input given
      if $(echo ${PROJECT_LIST} | grep -xq ${USER_INPUT});
        then
          # If input matches a project, change into that project. 
          printf "\033[0;32m\nChanging into repo:\033[0m \033[0;33m${USER_INPUT}\033[0m\n\n"
          cd "${PROJECT_DIR}/${USER_INPUT}"
          git status
        else 
          # Filter projects based on user input that could match locally
          printf "\nRepo '\033[0;33m${USER_INPUT}\033[0m' does not exist in \033[0;32m${PROJECT_DIR}\033[0m\n\nDid you mean one of these instead?\n\n"
          printf "local repos:\n\n"
          echo ${PROJECT_LIST} | grep "${USER_INPUT:0:3}" | xargs printf "\033[0;32m%s\n\033[0m"

          # Filter projects based on user input that could match via the github ${ORG_LIST}
          printf "\ngithub repos:\n\n"
          for ORG in ${ORG_LIST[@]};
            do 
              REPO_LIST=$(gh repo list ${ORG} -L 500 | awk -F' ' '{print $1}' | grep "${USER_INPUT}" | xargs printf "\033[0;32m%s\n\033[0m")
              if [[ -z "${REPO_LIST}" ]]
                then 
                  printf "None found matching: '\033[0;33m${USER_INPUT}\033[0m' in Org: '\033[0;33m${ORG}\033[0m'\n\n"
                else
                  #printf "\033[0;33m   ORG         REPO\n--------------------------------\033[0m\n"
                  echo "${REPO_LIST}"
              fi
          done
          printf "Use command: \033[0;33mgh repo clone \${ORG}/\${REPO} ${PROJECT_DIR}/\033[0m to clone.\n\n"
      fi
  else
    # If no input was given, change into the base ${PROEJCT_DIR}.
    printf "\033[0;32m\nChanging into the root project dir:\033[0m \033[0;33m${PROJECT_DIR}\033[0m\n\n"
    cd ${PROJECT_DIR}
  fi
}
