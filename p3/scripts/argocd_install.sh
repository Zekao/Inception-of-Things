echo "[INFO]   Installing argocd on server node (ip: $1)"

k3d cluster create argocd

echo "[INFO]  Successfully installed argocd on server node"

echo "[INFO]  Creating argocd namespace"

kubectl create namespace argocd

echo "[INFO]  Successfully created argocd namespace"

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[INFO]  Recovering argocd password and doing port forwarding"

echo -n "ArgoCD password:"	
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl port-forward svc/argocd-server -n argocd 8080:443