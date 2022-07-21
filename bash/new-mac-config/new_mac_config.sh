#!/bin/bash

# Lists of software to install #
BREW_INSTALLS="ansible awscli docker helm kubernetes-cli warrensbox/tap/tfswitch"
BREW_CASK_INSTALLS="1password google-chrome iterm2 slack spectacle visual-studio-code zoom private-internet-access brave-browser"

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
  if ! xcode-select -p >/dev/null 2>&1;
  then 
    # Install xcode 
    log_info "Installing xcode"
    xcode-select --install
    if [ "$?" -eq 1 ]
    then
      log_error "!! : Command failed"
      FAILED="$FAILED xcode"
    else 
        SUCCESS="${SUCCESS} xcode"
      fi
  fi

  if ! which brew >/dev/null 2>&1;
  then
    log_info "Installing Homebrew"
    # Once xcode is installed we can install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ "$?" -eq 1 ]
    then
      log_error "!! : Command failed"
      FAILED="$FAILED brew"
    else 
        SUCCESS="${SUCCESS} brew"
      fi
  fi

  # Run brew managed software installations 
  for i in "${BREW_INSTALLS}";
  do 
    if ! brew list "${i}" >/dev/null 2>&1;
    then
      log_info "Installing the following software: \n${i}"
      brew install "${i}"
      if [ "$?" -eq 1 ]
      then
        log_error "!! : Command failed"
        FAILED="$FAILED ${i}"
      else 
        SUCCESS="${SUCCESS} ${i}"
      fi
    fi
  done
   
  # Run brew cask managed software installations 
  for i in "${BREW_CASK_INSTALLS}";
  do 
    if ! brew list --cask "${i}" >/dev/null 2>&1;
    then
      log_info "Installing the following software: \n${i}"
      brew install --cask "${i}"
      if [ "$?" -eq 1 ]
      then
        log_error "!! : Command failed"
        FAILED="$FAILED ${i}"
      else 
        SUCCESS="${SUCCESS} ${i}"
      fi
    fi
  done

  if [ ! -d /Users/ian/.oh-my-zsh ]
  then
    # Install ohmyzsh 
    log_info "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ "$?" -eq 0 ]
    then
      log_error "!! : Command failed"
      FAILED="$FAILED ohmyzsh"
    fi
    SUCCESS="${SUCCESS} ohmyzsh"
    cp ./files/zshrc ~/.zshrc
  fi
}

function configs {
  ## Configure the dock ##
  # https://developer.apple.com/documentation/devicemanagement/dock

  # Show all hidden, recent apps, and active
  defaults write com.apple.dock showhidden -bool TRUE
  defaults write com.apple.dock showrecents -bool FALSE

  # Change to "suck" minimize behavior 
  defaults write com.apple.dock mineffect -string "suck"

  # Set the tileize, enable magnify, and set magnify size when hovering over dock items
  defaults write com.apple.dock tilesize -int 55
  defaults write com.apple.dock magnification -bool TRUE
  defaults write com.apple.dock largesize -int 70; killall Dock

  # Enable or Disable app launch automation
  defaults write com.apple.dock launchanim -bool TRUE

  # Remove all default apps 
  defaults delete com.apple.dock persistent-apps; killall Dock

  # Add custom apps to the dock
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Brave Browser.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iterm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/zoom.us.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/1Password.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

  # Kill/restart the dock to apply changes
  killall Dock

  # Resets back to defaults 
  # defaults delete com.apple.dock; killall Dock
  ## End Dock Config ##
}

SUCCESS=""
FAILED=""

log_info "Getting hardware info and updating the OS"
pre_reqs

log_info "Verifying apps are installed"
install_software

log_info "Configuring settings"
configs

if [ "${SUCCESS}" != "" ];
then
  log_info "Successful Installs: \n${SUCCESS}"
fi 

if [ "${FAILED}" != "" ];
then
  log_error "Failed Installs: \n${FAILED}"
fi