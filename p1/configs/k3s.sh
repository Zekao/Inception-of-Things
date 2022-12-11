#!/bin/bash
# This script is used to install k3s on a node

apk add curl
curl -sfL https://get.k3s.io | sh - 

