#!/bin/bash

echo "🚀 Setting up Kind (Kubernetes in Docker)..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Install kubectl if not exists
if ! command -v kubectl &> /dev/null; then
    echo "📦 Installing kubectl..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    else
        echo "❌ Unsupported OS. Please install kubectl manually."
        exit 1
    fi
fi

# Install Kind if not exists
if ! command -v kind &> /dev/null; then
    echo "📦 Installing Kind..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
        sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-darwin-amd64
        sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
    else
        echo "❌ Unsupported OS. Please install Kind manually."
        exit 1
    fi
fi

# Create Kind cluster configuration
cat > kind-config.yaml << EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

# Create Kind cluster
echo "🔧 Creating Kind cluster..."
kind create cluster --name voting-app --config kind-config.yaml

# Get kubeconfig
echo "📄 Getting kubeconfig..."
kind get kubeconfig --name voting-app > kubeconfig

# Create namespaces
echo "📦 Creating namespaces..."
kubectl create namespace voting-app
kubectl create namespace voting-app-staging

# Create secrets
echo "🔐 Creating secrets..."
kubectl create secret generic voting-app-secret \
    --from-literal=DB_USER=voting_user \
    --from-literal=DB_PASSWORD=voting_pass \
    -n voting-app

kubectl create secret generic voting-app-secret \
    --from-literal=DB_USER=voting_user \
    --from-literal=DB_PASSWORD=voting_pass \
    -n voting-app-staging

echo ""
echo "✅ Kind cluster setup completed!"
echo "📄 Kubeconfig file: $(pwd)/kubeconfig"
echo ""
echo "🔧 Useful commands:"
echo "  Check cluster status: kubectl cluster-info"
echo "  List nodes: kubectl get nodes"
echo "  Delete cluster: kind delete cluster --name voting-app"
echo ""
echo "📋 Next steps:"
echo "1. Copy kubeconfig file to Jenkins credentials"
echo "2. Deploy application using kubernetes/deploy.sh"
echo "3. Test pipeline with kubectl commands" 