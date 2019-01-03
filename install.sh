#!/bin/bash

echo "Installing Docker"
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
echo "Docker Installed Successfully"
echo "Installing Docker Compose"
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "Docker Compose Installed Successfully"

echo "Installing Git"
yum install -y git
echo "Git Installed Successfully"