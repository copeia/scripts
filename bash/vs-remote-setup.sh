#!/bin/sh

#Variables
VAGRANT_VERSION="2.2.18"

# Setup Logging Functions 
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

# Check for OS Type
if ( grep -is "centos\|redhat\|fedora" /etc/os-release ); then
    PKG_MGR="dnf"
    log_info "Using dnf as your package manager"

elif ( grep -is "ubuntu\|debian" /etc/os-release ); then
    PKG_MGR="apt-get"
    log_info "Using apt-get as your package manager"

else
    log_error "Not suitable OS found"
fi 

# Install Deps 
if [[ ${PKG_MGR} == "dnf" ]]; then
  log_info "Installing EPEL and dep packages"
  # Add repos and dep software 
  ${PKG_MGR} -y install epel-release
  ${PKG_MGR} -y install gcc \
      dkms \
      make \
      libgomp \
      patch \
      wget \
      git \
      tar \
      unzip \
      vim

  # Install virtualbox
  log_info "Installing VirtualBox"
    wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
    ${PKG_MGR} install -y VirtualBox-6.1-6.1.26_145957_el8-1.x86_64

elif [[ ${PKG_MGR} == "apt-get" ]]; then
  log_info ""
fi

# Install vagrant 
log_info "Installing Vagrant"
wget -O vagrant_${VAGRANT_VERSION}_x86_64.rpm https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.rpm
${PKG_MGR} install -y vagrant_${VAGRANT_VERSION}_x86_64.rpm

# Update the OS
log_info "Updating Everyting"
${PKG_MGR} clean makecache
${PKG_MGR} upgrade

# Setup ssh for github
log_info "Setting id_rsa to value defined in the authorized keys"
echo "$(cat ~/.ssh/authorized_keys | grep 'copeiaj@gmail.com')" > ~/.ssh/id_rsa

# Remove all downloaded files
log_info "Cleaning up"
rm -rf ./*.rpm