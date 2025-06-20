#!/bin/bash

echo "🗑️ Undeploying Voting App from Kubernetes..."

# Delete all resources in order
echo "🔧 Deleting Backend..."
kubectl delete -f backend-deployment.yaml --ignore-not-found=true

echo "🎨 Deleting Frontend..."
kubectl delete -f frontend-deployment.yaml --ignore-not-found=true

echo "🗄️ Deleting PostgreSQL..."
kubectl delete -f postgres-deployment.yaml --ignore-not-found=true

echo "🔐 Deleting secrets..."
kubectl delete -f secret.yaml --ignore-not-found=true

echo "📦 Deleting namespace..."
kubectl delete -f namespace.yaml --ignore-not-found=true

echo "✅ Undeployment completed!"
echo "🔍 To verify: kubectl get all -n voting-app" 