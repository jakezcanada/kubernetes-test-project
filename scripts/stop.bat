@echo off
setlocal enabledelayedexpansion

echo.
echo 🛑 Stopping and removing Kubernetes deployment...
echo.

echo 🗑️  Deleting frontend deployment...
kubectl delete deployment frontend -n app --ignore-not-found=true

echo 🗑️  Deleting frontend service...
kubectl delete svc frontend -n app --ignore-not-found=true

echo 🗑️  Deleting frontend configmap...
kubectl delete configmap frontend-config -n app --ignore-not-found=true

echo 🗑️  Deleting namespace...
kubectl delete namespace app --ignore-not-found=true

echo.
echo ✅ Cleanup complete!
echo.

echo Verify:
echo   kubectl get namespaces
echo   kubectl get pods --all-namespaces
echo.

pause
