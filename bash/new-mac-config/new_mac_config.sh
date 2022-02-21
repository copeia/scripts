#!/bin/bash

# Lists of software to install #
BREW_INSTALLS="ansible awscli docker helm kubernetes-cli warrensbox/tap/tfswitch"
BREW_CASK_INSTALLS="1password google-chrome iterm2 slack spectacle visual-studio-code zoom"

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

  # Update Mac 
  #softwareupdate -i -a
}

function install_software {
  if ! $(xcode-select -p)
  then 
    # Install xcode 
    log_info "Installing xcode"
    xcode-select --install
    if [ $? -eq 0 ]
    then
      log_error "!! : Command failed"
    fi
  fi

  if ! $(which brew >/dev/null 2>&1)
  then
  log_info "Installing Homebrew"
    # Once xcode is installed we can install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -eq 0 ]
    then
      log_error "!! : Command failed"
    fi
  fi

  # Run brew managed software installations 
  log_info "Installing the following list of software: \n\n${BREW_INSTALLS}"
  brew install ${BREW_INSTALLS}
   
  # Run brew cask managed software installations 
  log_info "Installing the following list of software: \n\n${BREW_CASK_INSTALLS}"
  brew install --cask ${BREW_CASK_INSTALLS}

  if [ ! -d /Users/ian/.oh-my-zsh ]
  then
    # Install ohmyzsh 
    log_info "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cp ./files/zshrc ~/.zshrc
  fi
}

function configs {
  # Configure custom defaults/settings
  # - background
  # - color theme 
  # - resolution and nightshift

  ## Configure the dock ##
  # https://developer.apple.com/documentation/devicemanagement/dock

  # Only show active apps
  defaults write com.apple.dock static-only -bool TRUE

  # Show all hidden apps
  defaults write com.apple.dock showhidden -bool TRUE

  # Disable showing recent apps 
  default write com.apple.dock showrecents-immutable -bool true

  # Change to "suck" minimize behavior 
  defaults write com.apple.dock mineffect suck

  # Set the magnify size when hovering over dock items
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -int 100

  # Enable or Disable app launch automation
  defaults write com.apple.dock launchanim -bool true

  # Kill/restart the dock to apply changes
  killall Dock

  # Resets back to defaults 
  # defaults delete com.apple.dock; killall Dock
}

#pre_reqs
install_software
#configs


# Final messages to user 
# - output installed software 
# - output failures 
# - output suggested items for manual config