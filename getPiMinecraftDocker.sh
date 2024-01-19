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
sleep 10
echo "### Starting Minecraftserver using Docker."
sudo docker run -d --restart unless-stopped --name mcserver -e MEMORYSIZE='1G' -e PAPERMC_FLAGS='' -v /home/pi/mcserver:/data:rw -p 25565:25565 -it marctv/minecraft-papermc-server:latest
echo "### Starting Watchdog to keep the container up to date"
sudo docker run -d --restart unless-stopped --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "3"
sleep 2
echo "2"
sleep 2
echo "1"
sleep 3
echo "### The installation is complete."
echo -e '\e[1m### The server will be started automatically after a reboot.\e[22m'
echo "### Running docker containers:"
sudo docker ps --format "{{.Names}}: {{.Image}}" --no-trunc
sleep 2
echo ""
echo -e '\e[1m### Wait at least 5 minutes for the server to start!\e[22m'
echo "Then open Minecraft. Select Multiplayer, Add Server, Server Address and put in this hostname:"
echo ""
echo $(hostname -I | cut -d' ' -f1)
echo ""
echo -e '\e[1m### If this does not work use the following command to reboot the pi. Sometimes this seems necessary.\e[22m'
echo "docker rm mcserver && docker rm watchtower && sudo reboot"
echo -e '\e[1m### Watchtower will try to update the Docker container at least once daily.\e[22m'
sleep 3
echo ""
echo "Find more information please visit https://github.com/mtoensing/RaspberryPiMinecraftDocker"
newgrp docker

