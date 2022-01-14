#!/bin/bash

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$1"
  log "INFO" "$message"
}

function log_warn {
  local -r message="$1"
  log "WARN" "$message"
}

function log_error {
  local -r message="$1"
  log "ERROR" "$message"
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
  # - brew
  # - pip
  # - awscli 
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