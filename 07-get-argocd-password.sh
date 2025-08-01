#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🔑 Getting ArgoCD initial admin password..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "✅ Password retrieved successfully:"
echo ""
echo "------------------------------------------------------------------"
echo "${PASSWORD}"
echo "------------------------------------------------------------------"
echo ""
echo "📋 Copy the password above and use it to login to the ArgoCD UI."
