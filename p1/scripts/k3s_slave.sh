#!/bin/bash

export TOKEN_PATH=/vagrant/tmp/node-token
export NAME="emaugaleSW"
echo "[INFO]  Installing k3s on server worker node (ip: $2)"

echo "[INFO]  Token path: $TOKEN_PATH"
echo "[INFO]  Token value: $(cat $TOKEN_PATH)"
export INSTALL_K3S_EXEC="agent --server https://$1:6643 --token-file $TOKEN_PATH --node-ip $2 --tls-san $NAME"

curl -sfL https://get.k3s.io |  sh -

sudo apt-get update
sudo apt-get install net-tools -y
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh # way to add alias on all users