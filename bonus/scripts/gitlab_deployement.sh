#!/bin/bash

export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/

helm search repo gitlab

helm install gitlab gitlab/gitlab-agent

# Check the differents options: `helm show values gitlab/gitlab-agent`

helm repo add gitlab https://charts.gitlab.io
helm repo update

# Install the GitLab Agent Helm chart on namespace gitlab

helm upgrade --install gitlab-agent gitlab/gitlab-agent \
    --set config.kasAddress='wss://kas.gitlab.emaugale.com' \
    --set config.token='supersecrettoken'

kubectl get secret gitlab-agent-token -o jsonpath='{.data.token}' | base64 --d

# configure the GitLab Agent Helm chart on namespace gitlab

