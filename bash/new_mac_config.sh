#!/bin/bash

# Source in our logging function script.
source ./functions/standard_logging.sh

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