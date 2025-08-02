#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Starting Kubernetes Dashboard..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

echo "🔑 To get the token, run: ./05-get-dashboard-token.sh"
echo "🔗 Access the dashboard at: https://localhost:8443"

kubectl -n kubernetes-dashboard port-forward svc/dashboard-kong-proxy 8443:443
