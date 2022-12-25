#!/bin/bash

export NAME="emaugaleSW"
echo "[INFO]  Installing k3s on server worker node (ip: $2)"

export INSTALL_K3S_EXEC="agent --server https://$1:6643 --token-file=/vagrant/$3 --node-ip $2 --tls-san $NAME"

apk add curl
curl -sfL https://get.k3s.io |  sh -

# sudo apt-get update
# sudo apt-get install net-tools -y
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh # way to add alias on all users