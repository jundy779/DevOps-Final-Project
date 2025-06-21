#!/bin/bash

# Script untuk setup Jenkins CI/CD Pipeline
echo "🚀 Setting up Jenkins CI/CD Pipeline..."

# Install Jenkins plugins yang diperlukan
echo "📦 Installing required Jenkins plugins..."

# Daftar plugin yang diperlukan
PLUGINS=(
    "workflow-aggregator"
    "git"
    "github"
    "docker-plugin"
    "kubernetes"
    "junit"
    "htmlpublisher"
    "email-ext"
    "blueocean"
    "pipeline-stage-view"
    "credentials-binding"
    "ssh-credentials"
    "plain-credentials"
    "docker-commons"
    "docker-workflow"
    "pipeline-utility-steps"
    "timestamper"
    "ws-cleanup"
    "build-timeout"
    "parameterized-trigger"
)

# Install plugins
for plugin in "${PLUGINS[@]}"; do
    echo "Installing plugin: $plugin"
    java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin "$plugin" -deploy
done

# Restart Jenkins
echo "🔄 Restarting Jenkins..."
java -jar jenkins-cli.jar -s http://localhost:8080/ safe-restart

echo "✅ Jenkins setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Access Jenkins at http://localhost:8080"
echo "2. Create new Pipeline job"
echo "3. Configure Git repository"
echo "4. Set up Docker registry credentials"
echo "5. Configure Kubernetes credentials"
echo ""
echo "🔧 Required configurations:"
echo "- Docker Registry: Update DOCKER_REGISTRY in Jenkinsfile"
echo "- Kubernetes: Configure kubectl access"
echo "- Email: Configure SMTP settings for notifications"
echo "- GitHub: Set up webhook for automatic triggers" 