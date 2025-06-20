#!/bin/bash

echo "🚀 Deploying Voting App to Kubernetes..."

# Create namespace
echo "📦 Creating namespace..."
kubectl apply -f namespace.yaml

# Create secrets
echo "🔐 Creating secrets..."
kubectl apply -f secret.yaml

# Deploy PostgreSQL
echo "🗄️ Deploying PostgreSQL..."
kubectl apply -f postgres-deployment.yaml

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n voting-app --timeout=300s

# Deploy Backend
echo "🔧 Deploying Backend..."
kubectl apply -f backend-deployment.yaml

# Deploy Frontend
echo "🎨 Deploying Frontend..."
kubectl apply -f frontend-deployment.yaml

# Wait for all pods to be ready
echo "⏳ Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=frontend -n voting-app --timeout=300s

# Get service information
echo "📊 Getting service information..."
kubectl get services -n voting-app

echo "✅ Deployment completed!"
echo "🌐 Frontend should be accessible via LoadBalancer IP"
echo "🔍 To check status: kubectl get pods -n voting-app"
echo "📝 To view logs: kubectl logs -f deployment/backend -n voting-app" 