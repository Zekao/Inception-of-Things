#!/bin/bash

export NAME="emaugaleSW"

echo "[INFO]  Installing k3s on server worker node (ip: $2)"


export k3s_token=$(cat /vagrant/$3)

echo " [INFO] TOKEN ON WORKER SIDE: $k3s_token"

export INSTALL_K3S_EXEC="agent --node-ip $2 --tls-san $NAME"

apk add curl

curl -sfL https://get.k3s.io | K3S_URL=https://$1:6443 K3S_TOKEN=${k3s_token} sh -

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh # way to add alias on all users