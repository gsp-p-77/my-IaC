#!/bin/bash

# Exit the script if any command fails
set -e

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add docker compose-plugin
sudo apt-get install -y docker-compose-plugin

sudo adduser --disabled-password --gecos '' itadmin

#Add itadmin user to docker group
usermod -aG docker itadmin

#Install unzip
sudo apt install unzip -y

#Install nginx and certbot
sudo apt install -y nginx certbot python3-certbot-nginx

sudo mkdir -p /etc/ssl/nginx
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/nginx/self-signed.key \
  -out /etc/ssl/nginx/self-signed.crt \
  -subj "/CN=188.245.158.254"


#Install portainer
docker volume create portainer_data
docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.0



