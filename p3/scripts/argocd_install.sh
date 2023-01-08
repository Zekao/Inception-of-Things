#!/bin/bash

echo "[INFO]   Installing argocd on server node (ip: $1)"

k3d cluster create argocd

echo "[INFO]  Successfully installed argocd on server node"

echo "[INFO]  Creating argocd & dev namespaces"

kubectl create namespace argocd
kubectl create namespace dev

echo "[INFO]  Successfully created argocd namespace"

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

while [[ $(kubectl get pods -n argocd -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True True True True True True True" ]]; \
 do echo "[INFO][ARGOCD]  Waiting all pods to be ready..." && sleep 10; done

kubectl apply -f /vagrant/scripts/deployement.yaml 

while [[ $(kubectl get pods -n dev -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; \
 do echo "[INFO][DEV]  Waiting all pods to be ready..." && sleep 10; done

echo -n "[INFO]  ArgoCD admin password: "

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo "[INFO]  Doing port forwarding"

kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443

echo "[INFO]  Access argocd at https://$1:8080"
