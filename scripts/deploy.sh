#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "Deploying to Kubernetes..."

echo "Checking Kubernetes context..."
if ! kubectl config current-context >/dev/null 2>&1; then
    echo "Error: kubectl has no current context."
    echo "Enable Kubernetes in Docker Desktop, start Minikube, or configure your target cluster, then run:"
    echo "  kubectl config get-contexts"
    echo "  kubectl config use-context <context-name>"
    exit 1
fi

# Build the Docker image
echo "Building frontend image..."
docker build -t frontend:latest ./frontend

echo "Checking Kubernetes cluster..."
if ! kubectl cluster-info; then
    echo "Error connecting to Kubernetes cluster"
    echo "Check that Docker Desktop Kubernetes, Minikube, or your target cluster is running and that kubectl is using the correct context."
    exit 1
fi

# Create namespace and deploy
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/frontend-configmap.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
kubectl rollout restart deployment/frontend -n app

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/frontend -n app --timeout=300s

echo ""
echo "Deployment complete!"
echo ""
echo "Pod status:"
kubectl get pods -n app

echo ""
echo "Service info:"
kubectl get svc -n app

echo ""
echo "Access your app:"
echo "   Local (Minikube/Docker Desktop):"
echo "   kubectl port-forward svc/frontend 3000:80 -n app"
echo "   Then visit: http://localhost:3000"
echo ""
echo "   Cloud (AWS/GCP/Azure):"
echo "   kubectl get svc -n app"
echo "   Use the EXTERNAL-IP from the output above"
