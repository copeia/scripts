#!/bin/bash

# Install pre-reqs
#jq, curl, screen

# Check to see if Minecraft is running
function check_status(){
    # Check if minecraft is running and assign process pid to var
    STATUS=`ps aux | grep minecraft | awk -F' ' '/java/ {print $2}'`

    if [ "${STATUS}" ]; then
	while kill -2 ${STATUS} >/dev/null 2>&1;
	do
	  printf "\e[0;31m.\e[0m"
          sleep 1
	done
    fi
    printf "\e[0;32mComplete!\e[0m\n"
}

# Check to see if we are running latest, if not, download and install
function latest(){
    # Get latest version and build
    VERSION=`curl -s https://papermc.io/api/v2/projects/paper | jq -r '.versions | last'`
    BUILD=`curl -s https://papermc.io/api/v2/projects/paper/versions/$VERSION | jq -r '.builds | last'`

    if [ $(cat current_version.txt) == $VERSION.$BUILD ];
    then
        printf "\e[0;32m\nCurrent Version:\e[0m $VERSION\n"
        printf "\e[0;32mCurrent Build:\e[0m $BUILD\n\n"
        printf "\e[0;32mAlready only latest, continuing\e[0m\n\n"
    else
         echo "${VERSION}.${BUILD}" > current_version.txt
	 printf "\e[0;32m\nFound new version, downloading\e[0m\n\n"

        # Download latest
        curl -s -o minecraft.jar https://papermc.io/api/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar
        rm -f /mnt/minecraft/minecaft.jar
        mv ./minecraft.jar /mnt/minecraft/minecaft.jar
    fi
}

# Startup the Minecraft service in a screen
function startup(){
    # Get System Memory, then set Minecraft server memory
    SYSTEM_MEMORY=`free -m | awk -F' ' '/Mem/ {print $2}'`
    MS_MEM=`echo | awk "{print $SYSTEM_MEMORY/1.5}" | awk -F. '{print $1}'`

    # Start the Minecraft server
    cd /mnt/minecraft
    SCREEN_CHECK=`screen -ls | awk -F' ' '/minecraft/ {print $1}'`

    # Kill old screen
    if [ "${SCREEN_CHECK}" ]; then
        printf "\e[0;32mKilling Old Screen\e[0m\n"
        screen -X -S ${SCREEN_CHECK} quit
    fi

    # In a new screen, start the Minecraft server
    printf "\e[0;32mStarting Minecraft Server Detached\e[0m\n"
    screen -t minecraft -d -m java -Xmx${MS_MEM}M -Xms${MS_MEM}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar minecraft.jar --nogui

    until tail -n17 /mnt/minecraft/logs/latest.log | grep -q "Done";
    do
	printf "\e[0;31m.\e[0m"
        sleep 1
    done
}

# Call check_status fuction, kill minecraft
printf "\e[0;32mKilling Minecraft\e[0m\n"
check_status

# Auto-Update
latest

# Start Minecraft
startup

printf "\e[0;32mComplete!\e[0m\n\n"