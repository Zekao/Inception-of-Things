#!/bin/bash

export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/

helm search repo gitlab

helm install gitlab gitlab/gitlab-agent

