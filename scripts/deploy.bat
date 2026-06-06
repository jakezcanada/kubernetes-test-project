@echo off
setlocal enabledelayedexpansion

REM Run from the repository root so relative Docker and Kubernetes paths work
REM no matter where this script is launched from.
pushd "%~dp0.." >nul || (
    echo Failed to switch to repository root
    exit /b 1
)

echo.
echo Deploying to Kubernetes...
echo.

echo Checking Kubernetes context...
kubectl config current-context >nul 2>nul
if errorlevel 1 (
    echo Error: kubectl has no current context.
    echo Enable Kubernetes in Docker Desktop, start Minikube, or configure your target cluster, then run:
    echo   kubectl config get-contexts
    echo   kubectl config use-context ^<context-name^>
    popd >nul
    exit /b 1
)

REM Build the Docker image
echo Building frontend image...
docker build -t frontend:latest ./frontend
if errorlevel 1 (
    echo Error building Docker image
    popd >nul
    exit /b 1
)

echo Checking Kubernetes cluster...
kubectl cluster-info
if errorlevel 1 (
    echo Error connecting to Kubernetes cluster
    echo Check that Docker Desktop Kubernetes, Minikube, or your target cluster is running and that kubectl is using the correct context.
    popd >nul
    exit /b 1
)

REM Create namespace and deploy
echo Applying Kubernetes manifests...
kubectl apply -f k8s\namespace.yaml
if errorlevel 1 goto :kubectl_error
kubectl apply -f k8s\frontend-configmap.yaml
if errorlevel 1 goto :kubectl_error
kubectl apply -f k8s\frontend-deployment.yaml
if errorlevel 1 goto :kubectl_error
kubectl apply -f k8s\frontend-service.yaml
if errorlevel 1 goto :kubectl_error
kubectl rollout restart deployment/frontend -n app
if errorlevel 1 goto :kubectl_error

echo Waiting for deployment to be ready...
kubectl rollout status deployment/frontend -n app --timeout=300s
if errorlevel 1 goto :kubectl_error

echo.
echo Deployment complete!
echo.

echo Pod status:
kubectl get pods -n app
echo.

echo Service info:
kubectl get svc -n app
echo.

echo Access your app:
echo    Local (Minikube/Docker Desktop^):
echo    kubectl port-forward svc/frontend 3000:80 -n app
echo    Then visit: http://localhost:3000
echo.
echo    Cloud (AWS/GCP/Azure^):
echo    kubectl get svc -n app
echo    Use the EXTERNAL-IP from the output above
echo.

popd >nul
pause
exit /b 0

:kubectl_error
echo Error applying Kubernetes manifests or waiting for rollout
popd >nul
exit /b 1
