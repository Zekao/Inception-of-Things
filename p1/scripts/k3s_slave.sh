#!/bin/bash

export NAME="emaugaleSW"
echo "[INFO]  Installing k3s on server worker node (ip: $2)"

export TOKEN_FILE="/vagrant/scripts/node-token"

echo "[INFO]  Token: $(cat $TOKEN_FILE)"

export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file $TOKEN_FILE --node-ip=$2"

echo "[INFO]  ARGUMENT PASSED TO INSTALL_K3S_EXEC: $INSTALL_K3S_EXEC"

apk add curl

curl -sfL https://get.k3s.io | sh -

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh # way to add alias on all users