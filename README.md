# k3s

This project contains a set of scripts to set up a k3s cluster with NGINX Ingress Controller, Kubernetes Dashboard, and ArgoCD.

## Scripts

- `01-start-k3s.sh`: Installs k3s. 
  - Pass `dev` as an argument to run in development mode (e.g., `./01-start-k3s.sh dev`). 
  - In development mode, `--tls-san` and `--kubelet-arg` are not used.
  - The script will not overwrite an existing kubeconfig file. If one is found, it will alert the user.
- `02-deploy-nginx-ingress.sh`: Deploys the NGINX Ingress Controller using Helm and installs cert-manager. 
  - If Helm is not installed, the script will install it automatically.
- `03-setup-dashboard.sh`: Installs the Kubernetes Dashboard using Helm and creates a service account for dashboard access.
- `04-start-dashboard.sh`: Starts the Kubernetes Dashboard using `kubectl port-forward`.
- `05-get-dashboard-token.sh`: Gets the token for the 'admin' service account.
- `06-install-argocd.sh`: Installs ArgoCD.
- `08-get-argocd-password.sh`: Gets the initial admin password for ArgoCD.
- `09-start-argocd-dashboard.sh`: Starts the ArgoCD dashboard using `kubectl port-forward`.

## Usage

The scripts should be executed in the following order:

1. `./01-start-k3s.sh` (or `./01-start-k3s.sh dev` for development)
2. `./02-deploy-nginx-ingress.sh`
3. `./03-setup-dashboard.sh`
4. `./04-start-dashboard.sh`
5. `./05-get-dashboard-token.sh`
6. `./06-install-argocd.sh`
7. `./08-get-argocd-password.sh`
8. `./09-start-argocd-dashboard.sh`

After running these scripts, you will have a fully functional k3s cluster with a Kubernetes Dashboard and ArgoCD.
