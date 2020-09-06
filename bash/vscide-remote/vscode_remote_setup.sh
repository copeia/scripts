#!/bin/bash
#################################################################
# Script to setup a remote server for vscode remote development #
#################################################################

# Colors:
# red=$'\e[1;31m'
# grn=$'\e[1;32m'
# yel=$'\e[1;33m'
# blu=$'\e[1;34m'
# mag=$'\e[1;35m'
# cyn=$'\e[1;36m'
# end=$'\e[0m'

# Install dep software 
printf "\e[1;32m\nInstalling Dependency Software...\e[0m\n\n"
dnf -y update 
dnf -y install wget tar vim zsh util-linux-user git dnf-plugins-core yum-utils

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf -y install docker-ce
systemctl enable --now docker

curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
mv docker-compose /usr/local/bin && sudo chmod +x /usr/local/bin/docker-compose

# Disable firewalld so container networking works
systemctl disable firewalld

function git(){
    # Configure github account access 
    git config --global user.name "Ian Copeland"
    git config --global user.email "copeiaj@gmail.com"
    ssh-keygen -q -t rsa -C "copeiaj@mgmail.com"
    git config --global color.ui true
    git config --global core.editor code

    # Print key for easy addition to github authed keys 
    printf "\e[1;32m\nAdd the following as an autheorized key to your github account.\e[0m\n\n"
    cat ~/.ssh/id_rsa.pub

    # Wait for user input so they have a chance to grab the ras key
    printf "\e[1;32m\nPress any key to continue\n\e[0m"
    while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
    exit ;
    fi
    done

    # Make projects directory
    mkdir ~/projects

}

function zsh(){
    # This function requries an authenticated github connection to allow download of the .zshrc profile.
    printf "\e[1;32m\nConfiguring zsh and installing oh-my-zsh\e[0m\n\n"

    # Change shell for the root user to zsh
    chsh -s /usr/bin/zsh root

    # Download and install oh-my-zh
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    
    # Clone scripts repo containing .zshrc file
    cd ~/projects
    git clone git@github.com:copeia/scripts.git
    cp ~/projects/scripts/bash/vscode-remote/.zshrc ~/.zshrc
    source ~/.zshrc
    cd ~/
}