echo "[INFO]   Installing docker on server node (ip: $1)"

snap install docker

echo "[INFO]  Successfully installed docker on server node"

echo "[INFO]  Installing k3d on server node (ip: $1)"

wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

echo "[INFO]  Successfully installed k3d on server node"