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

# Check to see if Minecraft is running
function kill_minecraft(){
  # Check if minecraft is running and assign process pid to var
  PID=`ps aux | grep "[j]ava" | awk -F' ' '{print $2}' | head -n1`

  # Kill the currently running MC
  if [ ! -z "${PID}" ]; then
    log_warn "Killing Minecraft"
	  kill -1 ${PID}
    sleep 15
  fi
  log_warn "Minecraft Killed"
}

# Check to see if we are running latest, if not, download and install
function get_latest_vers(){
    # Get latest version and build
    VERSION=`curl -s https://papermc.io/api/v2/projects/paper | jq -r '.versions | last'`
    BUILD=`curl -s https://papermc.io/api/v2/projects/paper/versions/${VERSION} | jq -r '.builds | last'`

    # Get the current version 
    CURRENT_VERSION=$(awk -F'(' '/currentVersion/ {print $2}' ${MC_LOCATION}/version_history.json | grep -Eo '[+-]?[0-9]+([.][0-9]+)+([.][0-9]+)?')

    if [ ${CURRENT_VERSION} == ${VERSION} ];
    then
        log_info "Current Version: ${VERSION}"
        log_info "Current Build: ${BUILD}"
        log_info "Already only latest, continuing"
    else
	    log_info "Found new version, downloading it now"

        # Download latest
        curl -s -o minecaft-${VERSION}.jar https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${BUILD}/downloads/paper-${VERSION}-${BUILD}.jar
        mv ./minecaft-${VERSION}.jar $MC_LOCATION/server_jars/
        chmod +x ${MC_LOCATION}/server_jars/* 
        log_info "Downloaded and moved to: ${MC_LOCATION}/server_jars/minecaft-${VERSION}.jar"
        # Change eula
        sed -i 's/eula=false/eula=true/g' ${MC_LOCATION}/eula.txt
    fi
}

# Startup the Minecraft service in a screen
function startup(){
    # Get System Memory, then set Minecraft server memory
    # Divide available system mem and divide by 1.25 when over 6gb and 1.5 when under
    SYSTEM_MEMORY=`free -m | awk -F' ' '/Mem/ {print $2}'`
    MS_MEM=`echo | awk "{print ${SYSTEM_MEMORY}/1.25}" | awk -F. '{print $1}'`
    VERSION=`curl -s https://papermc.io/api/v2/projects/paper | jq -r '.versions | last'`

    # Start the Minecraft server
    cd ${MC_LOCATION}

    # In a new screen, start the Minecraft server
    printf "\e[0;32mStarting Minecraft Server Detached\e[0m\n"
    tmux new -d -s minecraft-server
    tmux send-keys -t minecraft-server "set -g default-terminal 'screen-256color' && set -g history-limit 10000" C-m
    
    tmux send-keys -t minecraft-server "java -Xmx${MS_MEM}M -Xms${MS_MEM}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
        -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 \
        -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \
        -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
        -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MC_LOCATION/server_jars/minecaft-${VERSION}.jar --nogui &" C-m
    #tmux detach -s minecraft-server

    # until tail -n17 ${MC_LOCATION}/logs/latest.log | grep -q "Done" ;
    # do
	  #   printf "\e[0;31m.\e[0m"
    #     sleep 1
    # done
}

# Install/Upgrade Minecraft
UPGRADE=$1

# Directory where the minecraft server/worlds should live. 
MC_LOCATION=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Directory where the minecraft installation should live
mkdir -p $MC_LOCATION/server_jars >/dev/null

# Update all packages and install depts
log_info "Update all packages and installing deps"
dnf -y update >/dev/null
dnf -y install jq vim tmux >/dev/null
log_info "Complete"

# If not installed, install java-openjdk 17
if ! which java >/dev/null 2>&1;
then
  log_info "Installing Java-JDK"
  dnf -y install java-17-openjdk java-17-openjdk-devel >/dev/null
  log_info "Complete"
else 
  log_info "Java already installed, skipping"
fi

if [ "${UPGRADE}" == "true" ];
then
  # Call kill_minecraft fuction, kill minecraft
  kill_minecraft
  # Update Minecraft to latest
  get_latest_vers
else
  log_info "'true' param not passed when calling this script, minecraft will not be upgraded"
  log_info "Param passed like './startup.sh true'"
fi

# Start Minecraft
if ! ps aux | grep "[j]ava" >/dev/null;
then
  startup
else 
  log_info "Minecraft is already running"
fi
