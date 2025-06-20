#!/bin/bash

echo "🚀 Setting up Jenkins on Ubuntu VPS..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Java
echo "☕ Installing Java..."
sudo apt install -y openjdk-17-jdk

# Verify Java installation
java -version

# Add Jenkins repository
echo "📥 Adding Jenkins repository..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list
sudo apt update

# Install Jenkins
echo "📦 Installing Jenkins..."
sudo apt install -y jenkins

# Start and enable Jenkins
echo "🔄 Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
echo "⏳ Waiting for Jenkins to start..."
sleep 30

echo "🔑 Getting admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "✅ Jenkins setup completed!"
echo "🌐 Access Jenkins at: http://YOUR_VPS_IP:8080"
echo "🔑 Admin password: (see above)"
echo ""
echo "📋 Next steps:"
echo "1. Open http://YOUR_VPS_IP:8080 in your browser"
echo "2. Enter the admin password above"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Setup pipeline job"
echo ""
echo "🔧 Useful commands:"
echo "  Check status: sudo systemctl status jenkins"
echo "  View logs: sudo journalctl -u jenkins -f"
echo "  Restart: sudo systemctl restart jenkins"
echo "  Stop: sudo systemctl stop jenkins" 