#!/bin/sh
# curl -fsSL https://raw.githubusercontent.com/flyingoverclouds/AKSLab/refs/heads/main/vmsetup/vmsetup.sh -o $HOME/vmsetup.sh
# chmod +x $HOME/vmsetup.sh
# $HOME/vmsetup.sh
#
# OU execution automatique (possible de lancer via az vm invoke-command ... à tester): 
#       curl -fsSL https://raw.githubusercontent.com/flyingoverclouds/AKSLab/refs/heads/main/vmsetup/vmsetup.sh | sh
#
#----- update Linux
sudo apt update -y
sudo apt upgrade -y


#----- Install Docker ( from https://docs.docker.com/engine/install/ubuntu/ )
# previous docker install
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) -y

# Add Docker's official GPG key:
sudo apt update -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

# install docker engine
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#----- allow non root to user docker cli ( from docker post install task )
sudo groupadd docker
sudo usermod -aG docker $USER

#----- Installation AZ CLI ( from https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux )
curl -fsSL 'https://azurecliprod.blob.core.windows.net/$root/deb_install.sh' | sudo bash


#----- install Kubectl using azcli
sudo az aks install-cli

#----- install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

# add k alias
echo -e "alias k=kubectl\n" >> $HOME/.bashrc