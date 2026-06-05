# Kubernetes Deployment Scripts

Quick deploy and stop scripts for Kubernetes.

## Prerequisites

- `kubectl` installed and configured
- Docker installed (for building the image)
- Kubernetes cluster running (Minikube, Docker Desktop, or cloud provider)

## Deploy Script

### On Linux/Mac (Bash):
```bash
bash scripts/deploy.sh
```

### On Windows (CMD):
```cmd
scripts\deploy.bat
```

**What it does:**
1. Builds the frontend Docker image
2. Applies all Kubernetes manifests (namespace, configmap, deployment, service)
3. Waits for deployment to be ready
4. Shows pod and service status
5. Displays access instructions

## Stop Script

### On Linux/Mac (Bash):
```bash
bash scripts/stop.sh
```

### On Windows (CMD):
```cmd
scripts\stop.bat
```

**What it does:**
1. Deletes the frontend deployment
2. Deletes the frontend service
3. Deletes the configmap
4. Deletes the namespace
5. Cleans up everything

## Access the App

After deploying, choose one:

**Local development (Minikube/Docker Desktop):**
```bash
kubectl port-forward svc/frontend 3000:80 -n app
```
Then visit: `http://localhost:3000`

**Cloud environments (AWS/GCP/Azure):**
```bash
kubectl get svc -n app
```
Copy the EXTERNAL-IP and visit that IP in your browser.

## Troubleshooting

Check deployment status:
```bash
kubectl get pods -n app
kubectl describe pod <pod-name> -n app
kubectl logs <pod-name> -n app
```

View all resources:
```bash
kubectl get all -n app
```
