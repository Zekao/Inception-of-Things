#!/bin/sh

# Install k3s 
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip 192.168.56.110  --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "
curl -sfL https://get.k3s.io | sh -
sleep 10


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
sudo k3d cluster create argocd
sudo kubectl create namespace argocd 
sudo kubectl create namespace dev 
sleep 5

# Install ArgoCD
curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | kubectl apply -n argocd -f -
while [ $(kubectl get pods -n argocd | grep -o Running | wc -l) -ne 7 ] 
    do sleep 5
done

#Install Wil app 

kubectl apply -f /vagrant/scripts/deploy.yaml 

while [ $(kubectl get pods -n dev | grep -o Running | wc -l) -ne 1 ] 
    do sleep 5
done


echo -n "Password is :" 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
echo -m "Open your browser and go to http://192.168.56.110:8080" 


