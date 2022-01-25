#!/bin/bash

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 printf "[${timestamp}] [${level}] ${message}\n"
}

function log_info {
  local -r message="$1"
  log "\e[36mINFO\e[0m" "\e[36m$message\e[0m"
}

function log_warn {
  local -r message="$1"
  log "\e[33mWARN\e[0m" "\e[33m$message\e[0m"
}

function log_error {
  local -r message="$1"
  log "\e[31mERROR\e[0m" "\e[31m$message\e[0m"
}

function pre_reqs {  
  # Find Process Architecture 
  PROC_ARCH=$(uname -m)

  # Update all Mac software
  log_info "Updating OS & Existing Apps"
  softwareupdate -i -a
}

function install_software {

  log_info "Starting Software Installations"
  INSTALL_COMPLETE_LIST=""
  INSTALL_FAILED_LIST=""
  INSTALL_SKIPPED_LIST=""

  # Install User Software functions
  function install_sh_script {
    # Basic Shell Script Installs #
    ################################
    # Used like:
    # call_function app install_script/command

    if ! which $1 >/dev/null 2>&1;
    then
      log_info "Installing $1"
      $2
      if $?;
      then
        INSTALL_COMPLETE_LIST="$INSTALL_COMPLETE_LIST '$1'"
      else
        INSTALL_FAILED_LIST="$INSTALL_FAILED_LIST '$1'"
      fi
    else
      INSTALL_SKIPPED_LIST="$INSTALL_SKIPPED_LIST '$1'"
      log_info "($1) Already Installed"
      log_info "Install Location:" 
      which $1
      log_info "Version Info:"
      $1 --version 
    fi
  }

  function install_cp_app {
    # Basic download > move to /Applications #
    ##########################################
    # Used like:
    # call_function "app name" "download url"

    # Verify app installation status. Install if not already installed
    if ! ls /Applications/ | grep -i "$1" >/dev/null 2>&1;
    then
      log_info "Installing $1"
      curl -sO $2

      # Extract the archive containing the new application
      if ls ./ | grep ".zip";
      then
        unzip *.zip > /dev/null; rm -f *.zip > /dev/null
      elif ls ./ | grep ".tgz"
      then
       tar -xzf *.tgz > /dev/null; rm -f *.tgz > /dev/null
      fi

      # Move the extracted app into the /Applications dir
      mv -f *.app /Applications/

      # Verify installation status
      if $? >/dev/null 2>&1;
      then
        INSTALL_COMPLETE_LIST="$INSTALL_COMPLETE_LIST '$1'"
        log_info "Install Complete"
      else
        INSTALL_FAILED_LIST="$INSTALL_FAILED_LIST '$1'"
        log_error "Install Failed"
      fi
    else
      INSTALL_SKIPPED_LIST="$INSTALL_SKIPPED_LIST '$1'"
      log_info "($1) Already Installed"
      log_info "Install Location: /Applications/$1" 
    fi

  }

  function install_w_brew {
    # Brew Installs #
    #################
    # Used like:
    # call_function "List of apps to install"

    for app in $1;
    do 
      if ! brew list | grep $app >/dev/null;
      then
        log_info "Installing: $app"
        brew install $app >/dev/null
        if [ $? -eq 0 ];
        then
          INSTALL_COMPLETE_LIST="$INSTALL_COMPLETE_LIST '$app'"
        else
          INSTALL_FAILED_LIST="$INSTALL_FAILED_LIST '$app'"
        fi
      else 
        INSTALL_SKIPPED_LIST="$INSTALL_SKIPPED_LIST '$app'"
        log_info "$1 Already installed via (brew)"
      fi
    done
  }

  function install_dmg {
    # DMG Installs # 
    ################
    # Used like:
    # call_function "app name" "download url"

    if ! ls /Applications | grep -i "$1"; 
    then
      curl -O $2
      IMAGE=`ls ./ | grep dmg`
      sudo hdiutil attach ${IMAGE}
      cp -R /Volumes/$1/$1.app /Applications/
      if $? >/dev/null 2>&1;
      then
        INSTALL_COMPLETE_LIST="$INSTALL_COMPLETE_LIST '$1'"
        log_info "Install Complete"
      else
        INSTALL_FAILED_LIST="$INSTALL_FAILED_LIST '$1'"
        log_error "Install Failed"
      fi
      sudo hdiutil detach /Volumes/$1
      else 
        INSTALL_SKIPPED_LIST="$INSTALL_SKIPPED_LIST '$1'"
        log_info "($1) Already Installed"
        log_info "Install Location: /Applications/$1" 
    fi
  }

  function install_pkg {
    
    if ! ls /Applications | grep -i "$1"; 
    then
      curl -o $1.pkg $2
      sudo installer -package $1.pkg -target /
      if $? >/dev/null 2>&1;
      then
        INSTALL_COMPLETE_LIST="$INSTALL_COMPLETE_LIST '$1'"
        log_info "Install Complete"
      else
        INSTALL_FAILED_LIST="$INSTALL_FAILED_LIST '$1'"
        log_error "Install Failed"
      fi
      rm -f $1.pkg >/dev/null
    else
      INSTALL_SKIPPED_LIST="$INSTALL_SKIPPED_LIST '$1'"
      log_info "($1) Already Installed"
      log_info "Install Location:" 
      echo "/Applications/$1"
    fi

  }

  # Basic Shell Script Installs #
  if [ ! -d ~/.oh-my-zsh ];then install_sh_script "ohmyzsh" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"';fi
  install_sh_script "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  install_sh_script "aws" 'curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"; sudo installer -pkg AWSCLIV2.pkg -target /'
    rm -f AWSCLIV2.pkg >/dev/null 2>&1
  install_sh_script "ansible" "pip3 install --user ansible"
  
  # Brew Installs #
  install_w_brew "jq terraform helm wget"

  # Basic download > move to /Applications #
  install_cp_app "Visual Studio Code" "https://az764295.vo.msecnd.net/stable/899d46d82c4c95423fb7e10e68eba52050e30ba3/VSCode-darwin-universal.zip" 
  install_cp_app "iTerm" "https://iterm2.com/downloads/stable/iTerm2-3_4_15.zip"
  install_cp_app "Spectacle" "https://github.com/eczarny/spectacle/releases/download/1.2/Spectacle+1.2.zip"

  # DMG Installs # 
  install_dmg "Slack" "https://downloads.slack-edge.com/releases/macos/4.23.0/prod/universal/Slack-4.23.0-macOS.dmg"
  install_dmg "Google\ Chrome" "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
  if [ $PROC_ARCH != "arm64" ] && [ ! -f /Applications/Docker.app ];then install_dmg "Docker" "https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-amd64";elif [ $PROC_ARCH == "arm64" ] && [ ! -f /Applications/Docker.app ];then install_dmg "Docker" "https://desktop.docker.com/mac/main/arm64/Docker.dmg\?utm_source\=docker\&utm_medium\=webreferral\&utm_campaign\=docs-driven-download-mac-arm64";fi

  # PKG Installs #
  if [ $PROC_ARCH != "arm64" ];then install_pkg "Zoom" "https://zoom.us/client/latest/Zoom.pkg";elif [ $PROC_ARCH == "arm64" ];then  install_pkg "Zoom" "https://zoom.us/client/latest/Zoom.pkg?archType=arm64";fi


  # - kubectl 

}

function configs {
  # Configure custom defaults/settings
  # - background
  # - color theme 
  # - dock
  #   - remove recently used apps
  #   - fix size 
  #   - remove all default shortcuts 
  #   - 
  # - 
  echo ""
}

log_info "Starting New Mac Setup"
log_info "This installs the software defined in the install functions as well as configures the terminal and doc."

pre_reqs
install_software
#configs


# Final messages to user 
if [ ! -z "${INSTALL_SKIPPED_LIST}" ];
then 
  log_info "Installed Software:"
  for app in "${INSTALL_COMPLETE_LIST}";
  do 
    printf "${app}\n"
done
fi
if [ ! -z "${INSTALL_SKIPPED_LIST}" ];
then 
  log_info "Install Skipped:"
  for app in "${INSTALL_SKIPPED_LIST}";
  do 
    printf "${app}\n\n"
  done
fi
if [ ! -z "${INSTALL_FAILED_LIST}" ];
then
 log_error "Install Failed:"
 for app in "${INSTALL_FAILED_LIST}";
 do 
  printf "${app}"
done
fi
