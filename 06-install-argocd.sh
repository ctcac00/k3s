#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Installing ArgoCD..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

echo "📦 Creating argocd namespace..."
kubectl create namespace argocd

echo "📝 Applying ArgoCD manifests..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "🎉 ArgoCD installed successfully!"
echo "ℹ️  Run ./07-get-argocd-password.sh to get the admin password."
echo "ℹ️  Run 'kubectl port-forward svc/argocd-server -n argocd 8080:443' to access the ArgoCD UI."
