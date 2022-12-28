#!/bin/sh
apk add curl
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip 192.168.56.110  --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "
curl -sfL https://get.k3s.io | sh -
sleep 10
kubectl apply -f /vagrant/scripts/deploy.yaml