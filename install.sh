#!/bin/bash

# Script to install environment for helm-demo project

echo "🚀 Starting environment setup for helm-demo..."

# --- Prerequisites Check (Informational) ---
echo "ℹ️ Please ensure you have a Linux environment (Ubuntu/Debian recommended) with sudo privileges."
echo "ℹ️ This script assumes you are running in a Kubernetes playground with kubectl already configured."
echo "ℹ️ Required package managers: apt, curl, wget."
echo "--------------------------------------------------"
sleep 2

# --- Install Helm ---
echo "⚙️ Installing Helm..."
if command -v helm &> /dev/null; then
    echo "✅ Helm is already installed."
else
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
    echo "✅ Helm installed."
fi
echo "--------------------------------------------------"
sleep 1

# --- Install ArgoCD CLI ---
echo "⚙️ Installing ArgoCD CLI..."
if command -v argocd &> /dev/null; then
    echo "✅ ArgoCD CLI is already installed."
else
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
    echo "✅ ArgoCD CLI installed."
fi
echo "--------------------------------------------------"
sleep 1

# --- Install ArgoCD in Cluster ---
echo "⚙️ Installing ArgoCD in the cluster..."
kubectl get namespace argocd &> /dev/null
if [ $? -eq 0 ]; then
    echo "✅ ArgoCD namespace already exists."
else
    kubectl create namespace argocd
    echo "✅ ArgoCD namespace created."
fi

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "✅ ArgoCD manifests applied."
echo "--------------------------------------------------"
sleep 1

# --- Install NGINX Ingress Controller ---
echo "⚙️ Installing NGINX Ingress Controller..."
if helm status ingress-nginx -n ingress-nginx &> /dev/null; then
    echo "✅ NGINX Ingress Controller already installed."
else
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
    echo "✅ NGINX Ingress Controller installed."
fi
echo "--------------------------------------------------"
sleep 1

echo "🎉 Environment setup finished!"
echo "Next steps:"
echo "1. Verify cluster status: kubectl get nodes"
echo "2. Access ArgoCD UI. In a playground, you may need to set up port forwarding or use a provided URL."
echo "   Example for port-forwarding:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "   Then open https://localhost:8080 and log in with username 'admin' and the password from:"
echo "   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
echo "3. Refer to the README.md for Helm chart deployment instructions."