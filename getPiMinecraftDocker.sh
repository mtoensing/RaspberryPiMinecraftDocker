#!/bin/bash
# Minecraft Server Docker Installation Script for Raspberry Pi 64-Bit
# By Marc Tönsing
# V1.0
# https://getmc.marc.tv
# GitHub Repository: https://github.com/mtoensing/RaspberryPiMinecraftDocker
#
#
#
# Quick start 
# Step 1: Install Raspberry Pi OS 64-Bit and enable SSH.
#
# Step 2: Copy and then execute these commands on the shell of the Pi:
#
# curl -fsSL https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraftDocker/main/getPiMinecraftDocker.sh -o install-pi-docker-minecraft.sh 
# chmod +x install-pi-docker-minecraft.sh 
# ./install-pi-docker-minecraft.sh
#
# Step 3: Play Minecraft on an automatically updated server.
#
#
group=docker
if [ $(id -gn) != $group ]
then
    if [[ "$(uname -m)" != aarch64 ]]; then
        echo "Wrong OS detected!"
        echo "Please install Raspberry Pi OS LITE (64-Bit) first."
        exit 1
    fi
    echo "### Let's install Docker and Minecraft Server on a Pi."
    echo "### This will only take a few minutes to complete."
    echo "### Making sure we are in the home directory."
    cd
    echo "### Create directoy ~/mcserver"
    mkdir mcserver
    echo "### Download docker installation script from get.docker.com"
    curl -fsSL https://get.docker.com -o get-docker.sh
    echo "### Make the docker script executable."
    chmod +x get-docker.sh 
    echo "### Run Docker installation script."
    ./get-docker.sh 
    echo "### Install uidmap."
    sudo apt-get install -y uidmap
    echo "### Setup dockerd-rootless."
    dockerd-rootless-setuptool.sh install
    echo "### Add user to docker group."
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo loginctl enable-linger pi
    echo "### Log in to new group docker."
fi
# From https://stackoverflow.com/questions/299728/how-do-you-use-newgrp-in-a-script-then-stay-in-that-group-when-the-script-exits/8363574#8363574
# If you have a better solution, please provide a PR.
group=docker
if [ $(id -gn) != $group ]
then
    # Construct an array which quotes all the command-line parameters.
    arr=("${@/#/\"}")
    arr=("${arr[*]/%/\"}")
    exec sg $group "$0 ${arr[@]}"
fi
echo "### Wait 5 seconds to make sure docker is up."
sleep 5
echo "### Starting Minecraftserver using Docker."
docker run -d --restart unless-stopped --name mcserver -e MEMORYSIZE='1G' -e PAPERMC_FLAGS='' -v /home/pi/mcserver:/data:rw -p 25565:25565 -it marctv/minecraft-papermc-server:latest
echo "### Starting Watchdog to keep the container up to date"
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "### Show running docker containers."
docker ps 
echo "### 3"
sleep 2
echo "### 2"
sleep 2
echo "### 1"
sleep 3
echo "### Finished installation!"
sleep 2
echo "###"
echo "###"
echo "###"
echo -e '\e[1m### Now open Minecraft. Select Mutliplayer, Add Server, Server Address and put in this hostname:\e[22m' $(hostname -I | cut -d' ' -f1)
echo "###"
echo "### It may take some time to start the server for the first time. You can check with the following two commands what the status is:"
echo "newgrp docker"
echo "docker logs mcserver"
echo "Press Ctrl-X to exit the docker log." 
echo "### You can find more information and support here: https://github.com/mtoensing/RaspberryPiMinecraftDocker"
