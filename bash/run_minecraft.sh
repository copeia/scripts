#!/bin/bash

# Set VM Memory
MEMORY=4000

# Get Minecraft server memory - Best practice use half the server memory for the minecraft jar. This assumes single tenancy 
MS_MEM=`echo $(($MEMORY/2))`

# Check if minecraft is running and assin process pid to var
STATUS=`ps aux | grep minecraft | awk -F' ' '/java/ {print $2}'`

# Check to see if Minecraft is running
function check_status(){
    if [ "${STATUS}" ]; then
        printf "\e[0;32mKilling Minecraft\e[0m\n"
        kill -2 ${STATUS}
        sleep 3
        STATUS=`ps aux | grep minecraft | awk -F' ' '/java/ {print $2}'`
        check_status
    fi
}

# Call check_status fuction
check_status

# Start the Minecraft server
cd /mnt/minecraft
SCREEN_CHECK=`screen -ls | awk -F' ' '/minecraft/ {print $1}'`

if [ "${SCREEN_CHECK}" ]; then
    printf "\e[0;32mKilling Old Screen\e[0m\n"
    screen -X -S ${SCREEN_CHECK} quit
fi

printf "\e[0;32mStarting Minecraft Server Detached\e[0m\n"
screen -t minecraft -d -m java -Xmx${MS_MEM}M -Xms${MS_MEM}M -jar minecraft.jar --nogui