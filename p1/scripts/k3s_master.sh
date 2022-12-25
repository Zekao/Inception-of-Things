#!/bin/bash

echo "[INFO]  Installing k3s on server node (ip: $1)"

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san emaugaleS --node-ip $1  --bind-address=$1 --advertise-address=$1 "

curl -sfL https://get.k3s.io |  sh -

sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/tmp/

sudo apt-get update
sudo apt-get install net-tools -y   

echo "[INFO]  Successfully installed k3s on server node"

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh # way to add alias on all users

source ~/.bashrc
