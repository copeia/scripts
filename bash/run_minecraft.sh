#!/bin/bash

# Configure script logging 
function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 printf "[${timestamp}] [${level}] ${message}\n"
}

function log_info {
  local -r message="$1"
  log "\e[36mINFO\e[0m" "\e[36m$message.\e[0m"
}

function log_warn {
  local -r message="$1"
  log "\e[33mWARN\e[0m" "\e[33m$message.\e[0m"
}

function log_error {
  local -r message="$1"
  log "\e[31mERROR\e[0m" "\e[31m$message.\e[0m"
}

function command() {
  # Get System Memory, then set Minecraft server memory
  # Divide available system mem and divide by 1.25 when over 6gb and 1.5 when under
  SYSTEM_MEMORY=`free -m | awk -F' ' '/Mem/ {print $2}'`
  MS_MEM=`echo | awk "{print ${SYSTEM_MEMORY}/1.25}" | awk -F. '{print $1}'`
  # Start the Minecraft server
  cd ${MC_LOCATION}

  # In a new screen, start the Minecraft server
  log_warn "Starting Minecraft Server ${VERSION} Detached"
  tmux new -d -s minecraft-server
  tmux send-keys -t minecraft-server "set -g default-terminal 'screen-256color' && set -g history-limit 10000" C-m
  tmux send-keys -t minecraft-server "java -Xmx${MS_MEM}M -Xms${MS_MEM}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
      -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 \
      -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \
      -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
      -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MC_LOCATION/server_jars/minecaft-${VERSION}.jar --nogui" C-j
}

# Check to see if we are running latest, if not, download and install
function get_latest_vers(){

  if [[ "${1}" != "latest" ]]
    then 
      VERSION="${1}"
      BUILD=`curl -s https://papermc.io/api/v2/projects/paper/versions/${VERSION} | jq -r '.builds | last'`
    else
      # Get latest version and build
      VERSION=`curl -s https://papermc.io/api/v2/projects/paper | jq -r '.versions | last'`
      BUILD=`curl -s https://papermc.io/api/v2/projects/paper/versions/${VERSION} | jq -r '.builds | last'`
      log_warn "Latest Version ${VERSION} ${BUILD}"
  fi
    
  # Get the current version 
  CURRENT_VERSION=$(awk -F'(' '/currentVersion/ {print $3}' ${MC_LOCATION}/version_history.json | grep -Eo '[+-]?[0-9]+([.][0-9]+)+([.][0-9]+)?')

  if [ "${CURRENT_VERSION}" == "${VERSION}" ];
  then
      log_info "Current Version: ${VERSION}"
      log_info "Current Build: ${BUILD}"
      log_info "Already there... Bud."
  else	        
    log_info "Found requested version, downloading it now."

    # Download latest
    curl -s -o minecaft-${VERSION}.jar https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${BUILD}/downloads/paper-${VERSION}-${BUILD}.jar
    mv ./minecaft-${VERSION}.jar $MC_LOCATION/server_jars/
    chmod +x ${MC_LOCATION}/server_jars/* 
    log_info "Downloaded and moved to: ${MC_LOCATION}/server_jars/minecaft-${VERSION}.jar"
    # Change eula
    sed -i 's/eula=false/eula=true/g' ${MC_LOCATION}/eula.txt
    VERSION_CHANGED=true
  fi
}

# Startup the Minecraft service in a screen
function startup(){
  VERSION="${1}"
  
  if $($(tmux ls | grep -q "minecraft" >/dev/null 2>&1) && [ "${VERSION_CHANGED}" == true ]) || [ "${VERSION}" == "restart" ]
    then
      # If just restarting the service, check current version in config and run with that.
      if [ "${VERSION}" == "restart" ]
        then
          VERSION=$(awk -F'(' '/currentVersion/ {print $3}' ${MC_LOCATION}/version_history.json | grep -Eo '[+-]?[0-9]+([.][0-9]+)+([.][0-9]+)?')
      fi
      
      log_warn "Shutting down Minecraft - this could take 60 seconds or more"
      tmux send-keys -t minecraft-server 'say "shutting down in 1 minute for maintenance"\t'
      sleep 60
      tmux send-keys -t minecraft-server 'stop' C-j
      tmux send-keys -t minecraft-server 'exit' C-j
      tmux kill-ses -t minecraft-server

      # Call start function
      command
    elif $(tmux ls | grep -q "minecraft" >/dev/null 2>&1)
      then
        log_warn "Minecraft already running, please pass a new version or 'restart' to restart the service"
    else 
      # Call start function
      command
  fi
}

##################
## Script Entry ##
##################

# This should be run from the where the minecraft server files will live
# Ex:
#    ./run_minecraft.sh latest

# Install/Upgrade Minecraft
UPGRADE=$1
VERSION_CHANGED=false

# Directory where the minecraft server/worlds should live. 
MC_LOCATION=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Directory where the minecraft installation should live
mkdir -p $MC_LOCATION/server_jars >/dev/null

# Update all packages and install depts
log_info "Update all packages and install dnf packages"
dnf -y update >/dev/null
dnf -y install jq vim tmux >/dev/null
log_info "dnf changes Complete"

# If not installed, install java-openjdk 17
if ! which java >/dev/null 2>&1;
then
  log_info "Installing Java-JDK"
  dnf -y install java-17-openjdk java-17-openjdk-devel >/dev/null
  log_info "Complete"
else 
  log_info "Java already installed, skipping.."
fi

# Run mc functions based on user input
case $UPGRADE in
  latest)
    # Update Minecraft to latest
    log_info "Latest version requested"
    get_latest_vers "latest"
    startup "${VERSION}"
  ;;
  "")
    log_info "No minecraft server version change requested"
    startup "$(awk -F'(' '/currentVersion/ {print $2}' ${MC_LOCATION}/version_history.json | grep -Eo '[+-]?[0-9]+([.][0-9]+)+([.][0-9]+)?')"
  ;;
  restart)
    startup "restart"
  ;;
  *)
    log_info "Minecraft server version $UPGRADE requested"
    # Update Minecraft to latest
    get_latest_vers "${UPGRADE}"
    startup "$UPGRADE"
  ;;
esac
