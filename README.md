# Raspberry Pi Minecraft Java Docker
Install a Minecraft Java Server and Watchtower for automatic updates using Docker within seconds. Both will start automatically after a reboot.

# Quick start 

## Step 1: Install Raspberry Pi OS 64-Bit and enable SSH.

## Step 2: Copy and then execute these commands on the shell of the Pi.

```sh
curl -fsSL https://raw.githubusercontent.com/mtoensing/RaspberryPiMinecraftDocker/main/getPiMinecraftDocker.sh -o install-pi-docker-minecraft.sh 
chmod +x install-pi-docker-minecraft.sh 
./install-pi-docker-minecraft.sh
```

## Step 3: Start Minecraft and connect to the hostname display at the end of the installation.

## Step 4 (optional): Check the log of the server:

```sh 
newgrp docker
docker logs mcserver
```

Press Ctrl-X to exit the docker log.

## Step 5 (optional): Go the command line of the server 

```sh 
newgrp docker
docker attach mcserver
```

Here you can use commands like 

```sh 
op [username] 
whitelist add [username] 
```

Press Ctrl-P, followed by Ctrl-Q to exit.
