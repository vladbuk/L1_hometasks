#!/bin/bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common mc -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sleep 5
sudo apt install -y docker-ce
sudo systemctl status docker
sudo usermod -aG docker ubuntu
sudo apt install -y nginx