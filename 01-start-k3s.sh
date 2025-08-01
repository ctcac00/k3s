#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🚀 Starting k3s setup..."

echo "🧹 Uninstalling any previous k3s installation..."
if [ -x "/usr/local/bin/k3s-uninstall.sh" ]; then
    /usr/local/bin/k3s-uninstall.sh
else
    echo "🤔 k3s-uninstall.sh not found, skipping uninstall."
fi

echo "📦 Installing k3s..."
echo "ℹ️  Disabling Traefik to allow installation of NGINX Ingress Controller."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable=traefik" sh -

echo "📝 Copying kubeconfig to your home directory..."
mkdir -p "${HOME}/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "${HOME}/.kube/config"
sudo chown "$(id -u):$(id -g)" "${HOME}/.kube/config"
echo "✅ Kubeconfig copied successfully."

echo "🎉 k3s setup finished successfully!"
echo "ℹ️  Run 'kubectl get nodes' to check the status of your node."
