#!/bin/bash

echo "🚀 Setting up Minikube for local Kubernetes cluster..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Install kubectl if not exists
if ! command -v kubectl &> /dev/null; then
    echo "📦 Installing kubectl..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    else
        echo "❌ Unsupported OS. Please install kubectl manually."
        exit 1
    fi
fi

# Install Minikube if not exists
if ! command -v minikube &> /dev/null; then
    echo "📦 Installing Minikube..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
        sudo install minikube-darwin-amd64 /usr/local/bin/minikube
    else
        echo "❌ Unsupported OS. Please install Minikube manually."
        exit 1
    fi
fi

# Start Minikube cluster
echo "🔧 Starting Minikube cluster..."
minikube start --driver=docker --memory=4096 --cpus=2

# Enable addons
echo "🔧 Enabling addons..."
minikube addons enable ingress
minikube addons enable metrics-server

# Get kubeconfig
echo "📄 Getting kubeconfig..."
minikube kubectl -- config view --minify --flatten > kubeconfig

# Create namespaces
echo "📦 Creating namespaces..."
kubectl create namespace voting-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace voting-app-staging --dry-run=client -o yaml | kubectl apply -f -

# Create secrets
echo "🔐 Creating secrets..."
kubectl create secret generic voting-app-secret \
    --from-literal=DB_USER=voting_user \
    --from-literal=DB_PASSWORD=voting_pass \
    -n voting-app --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic voting-app-secret \
    --from-literal=DB_USER=voting_user \
    --from-literal=DB_PASSWORD=voting_pass \
    -n voting-app-staging --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "✅ Minikube setup completed!"
echo "🌐 Access Minikube dashboard: minikube dashboard"
echo "📄 Kubeconfig file: $(pwd)/kubeconfig"
echo ""
echo "🔧 Useful commands:"
echo "  Check cluster status: minikube status"
echo "  Stop cluster: minikube stop"
echo "  Delete cluster: minikube delete"
echo "  Get cluster IP: minikube ip"
echo ""
echo "📋 Next steps:"
echo "1. Copy kubeconfig file to Jenkins credentials"
echo "2. Deploy application using kubernetes/deploy.sh"
echo "3. Test pipeline with kubectl commands" 