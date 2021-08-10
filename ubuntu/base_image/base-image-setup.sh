#!/usr/bin/env bash

# apt-get install dos2unix -y

apt-get update -y && apt-get upgrade -y

add-apt-repository ppa:git-core/ppa -y

apt update -y

apt upgrade -y

apt install software-properties-common -y

add-apt-repository ppa:deadsnakes/ppa -y

apt install python3.9 -y

apt install python3-pip -y

apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt-get update -y

apt-get install docker-ce docker-ce-cli containerd.io -y

cpu_arch=$(uname -m)

if [[ "$cpu_arch" != "x86_64" ]]
then
	sudo apt-get install docker-compose -y
else
	sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi
docker-compose --version
