#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Setting up Kubernetes Dashboard..."

if ! command -v helm &> /dev/null; then
    echo "❌ Error: helm is not installed!"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

echo "➕ Adding Kubernetes Dashboard Helm repository..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
echo "✅ Repository added."

echo "🔄 Updating Helm repositories..."
helm repo update
echo "✅ Repositories updated."

echo "📦 Installing Kubernetes Dashboard..."
helm install dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace
echo "✅ Dashboard installed."

echo "👤 Creating service account for dashboard access..."

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin
    namespace: kubernetes-dashboard
EOF

echo "✅ Service account created successfully!"

echo "🎉 Kubernetes Dashboard setup finished successfully!"
