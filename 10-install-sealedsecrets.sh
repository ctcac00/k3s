#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Installing Sealed Secrets..."

if ! command -v helm &>/dev/null; then
  echo "🤔 Helm not found. Installing it..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  rm get_helm.sh
  echo "✅ Helm installed."
fi

echo "📥 Adding Sealed Secrets Helm repository..."
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

echo "📦 Installing Sealed Secrets controller..."
helm install sealed-secrets sealed-secrets/sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller

echo "📥 Installing kubeseal CLI..."
KUBESEAL_VERSION="0.30.0"
wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"
tar -xvzf "kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
rm kubeseal "kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"


echo "✅ Sealed Secrets controller installed."

echo "🎉 Sealed Secrets installed successfully!"