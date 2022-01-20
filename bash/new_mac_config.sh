#!/bin/bash

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$1"
  log "\e[36mINFO\e[0m" "$message"
}

function log_warn {
  local -r message="$1"
  log "\e[33mWARN\e[0m" "$message"
}

function log_error {
  local -r message="$1"
  log "\e[31mERROR\e[0m" "$message"
}

function pre_reqs {
  # Find Mac OS Version
  
  # Find Process Architecture 
  PROC_ARCH=$(uname -m)

  # Update Mac 
  softwareupdate -i -a
}

function install_software {
  # Install Softwares

  INSTALL_COMPLETE=""
  INSTALL_FAILED=""

  function install_bash {
    if ! $(which $1 &>/dev/null);
    then
      echo "Installing $1"
      `$2`
      if $?;
      then
        INSTALL_COMPLETE="$INSTALL_COMPLETE $1"
      else
        INSTALL_FAILED="$INSTALL_COMPLETE $1"
      fi
    else
      echo "brew already installed"
    fi
  }

  # Install Homebrew
  install_bash brew $(/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
  
  # Install awscli 
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  if ! $(grep "$HOME/Library/Python/3.9/bin")
  then
    PATH_LOOKUP=$(grep "export PATH" ~/.zshrc)
    sed "s#$PATH_LOOKUP# export PATH=$HOME/bin:/usr/local/bin:$HOME/Library/Python/3.9/bin:$PATH"
    export PATH=$HOME/bin:/usr/local/bin:$HOME/Library/Python/3.9/bin:$PATH
  fi 
  rm -f AWSCLIV2.pkg

  # - vscode 
  # - iterm2
  # - zsh
  # - ohmyzsh 
  # - slack 
  # - zoom
  # - chrome
  # - spectacle
  # - terraform 
  # - docker 
  # - ansible 
  # - kubectl 
  # - helm 
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
}

pre_reqs
install_software
configs


# Final messages to user 
# - output installed software 
# - output failures 
# - output suggested items for manual config