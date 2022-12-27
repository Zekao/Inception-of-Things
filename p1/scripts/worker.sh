#!/bin/sh
export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --token-file /home/vagrant/scripts/node-token --node-ip=192.168.56.111"

apk add curl
curl -sfL https://get.k3s.io | sh -
