# Minecraft Server 1.20+ on a Raspberry Pi using Docker

Install a Minecraft Java Server and Watchtower for automatic updates using Docker within seconds. Both will start automatically after a reboot. 

In-depth article about the installation (German): https://marc.tv/minecraft-java-raspberry-pi-docker/ 

# Quick start 

## Step 1: Install Raspberry Pi OS 64-Bit and enable SSH.

## Step 2: Copy and then execute these commands on the shell of the Pi.

```sh
curl -fsSL https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraftDocker/main/getPiMinecraftDocker.sh -o install-pi-docker-minecraft.sh 
chmod +x install-pi-docker-minecraft.sh 
./install-pi-docker-minecraft.sh
```

## Step 3: Start Minecraft and connect

Select Mutliplayer, Add Server, Server Address and put in the hostname that is displayed at the end of the installation.

## Step 4 (optional): Check the log of the server:

```sh 
docker logs mcserver
```

*Press Ctrl-C to exit the docker log.*

## Step 5 (optional): Go the command line of the server 

```sh 
docker attach mcserver
```

Here you can use commands like 

```sh 
op [username] 
whitelist add [username] 
```

*Press Ctrl-P, followed by Ctrl-Q to exit.*

## Useful commands

Before you report a problem, check with the following command if the containers are running. 

```sh 
docker ps
```
 
To start the container manually: 

```sh 
docker start mcserver
```

# Video Tutorial

[![Watch the video](https://img.youtube.com/vi/BuHOyhM2fCg/maxresdefault.jpg)](https://youtu.be/BuHOyhM2fCg)
