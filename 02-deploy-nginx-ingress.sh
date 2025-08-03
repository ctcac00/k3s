#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Deploying NGINX Ingress Controller for k3s..."

if ! command -v helm &>/dev/null; then
  echo "🤔 Helm not found. Installing it..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  rm get_helm.sh
  echo "✅ Helm installed."
fi

echo "Applying NGINX Ingress deployment manifest..."
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
echo "✅ NGINX Ingress manifest applied."

echo "Applying CertManager deployment manifest..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
echo "✅ CertManager deployment manifest applied."

echo "🎉 NGINX Ingress Controller deployed successfully!"