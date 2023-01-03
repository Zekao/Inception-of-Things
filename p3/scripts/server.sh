#!/bin/sh

# install docker on ubuntu 
sudo apt-get update -y 
sudo apt-get install ca-certificates curl gnupg lsb-release -y 
sudo mkdir -p /etc/apt/keyrings 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y 

# Install k3d 
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sleep 10 
k3d cluster create argocd
k3d create namespace argocd 
k3d create namespace dev 
sleep 5
curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | kubectl apply -n argocd -f -
sleep 25 

