#!/bin/bash

set -e

echo "🚀 Deploying to Kubernetes..."

# Build the Docker image
echo "📦 Building frontend image..."
docker build -t frontend:latest ./frontend

# Create namespace and deploy
echo "🔧 Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/frontend-configmap.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml

echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/frontend -n app --timeout=300s

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Pod status:"
kubectl get pods -n app

echo ""
echo "🌐 Service info:"
kubectl get svc -n app

echo ""
echo "🔗 Access your app:"
echo "   Local (Minikube/Docker Desktop):"
echo "   kubectl port-forward svc/frontend 3000:80 -n app"
echo "   Then visit: http://localhost:3000"
echo ""
echo "   Cloud (AWS/GCP/Azure):"
echo "   kubectl get svc -n app"
echo "   Use the EXTERNAL-IP from the output above"
