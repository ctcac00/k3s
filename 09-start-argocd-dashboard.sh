#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Starting ArgoCD Dashboard..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

echo "🔑 To get the password, run: ./07-get-argocd-password.sh"
echo "🔗 Access the dashboard at: http://localhost:8080"

kubectl -n argocd port-forward svc/argocd-server 8080:443
