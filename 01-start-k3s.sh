#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Starting k3s setup..."

IS_DEV_SERVER=false
if [ "${1:-}" = "dev" ]; then
  IS_DEV_SERVER=true
  echo "ℹ️  'dev' argument detected. Running in development mode."
else
  echo "ℹ️  No 'dev' argument. Running in production mode."
  echo "   To run in development mode, use: $0 dev"
fi

echo "🧹 Uninstalling any previous k3s installation..."
if [ -x "/usr/local/bin/k3s-uninstall.sh" ]; then
  /usr/local/bin/k3s-uninstall.sh
else
  echo "🤔 k3s-uninstall.sh not found, skipping uninstall."
fi

echo "📦 Installing k3s..."
echo "ℹ️  Disabling Traefik to allow installation of NGINX Ingress Controller."

if [ "$IS_DEV_SERVER" = true ]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable=traefik" sh -s -
else

  echo "🔎 Installing AWS ECR Credential Provider..."
  wget https://github.com/dntosas/ecr-credential-provider/releases/download/v1.2.0/ecr-credential-provider-linux-amd64
  chmod +x ecr-credential-provider-linux-amd64
  sudo mv ecr-credential-provider-linux-amd64 /usr/local/bin/ecr-credential-provider

  echo "🔎 Getting public IP address..."
  PUBLIC_IP=$(curl -4 -s ifconfig.me)
  echo "✅ Public IP address is: ${PUBLIC_IP}"
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable=traefik --tls-san ${PUBLIC_IP}" sh -s - \
    --kubelet-arg="image-credential-provider-config=/etc/kubernetes/ecr-credential-provider.json" \
    --kubelet-arg="image-credential-provider-bin-dir=/usr/local/bin"
fi

echo "📝 Setting up kubeconfig..."
mkdir -p "${HOME}/.kube"
if [ -f "${HOME}/.kube/config" ]; then
  echo "⚠️  Existing kubeconfig found at ${HOME}/.kube/config."
  echo "   Please manually merge the k3s config from /etc/rancher/k3s/k3s.yaml if needed."
else
  echo "ℹ️  No existing kubeconfig found. Copying k3s config..."
  sudo cp /etc/rancher/k3s/k3s.yaml "${HOME}/.kube/config"
  sudo chown "$(id -u):$(id -g)" "${HOME}/.kube/config"
  chmod 600 "${HOME}/.kube/config"
  echo "✅ Kubeconfig copied successfully."
fi

echo "🎉 k3s setup finished successfully!"
echo "ℹ️  Run 'kubectl get nodes' to check the status of your node."
