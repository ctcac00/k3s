#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Deploying NGINX Ingress Controller for k3s..."

if ! command -v helm &>/dev/null; then
  echo "❌ Error: helm is not installed!"
  exit 1
fi

echo "Applying NGINX Ingress deployment manifest..."
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
echo "✅ NGINX Ingress manifest applied."

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.2/cert-manager.yaml

echo "🎉 NGINX Ingress Controller deployed successfully!"
