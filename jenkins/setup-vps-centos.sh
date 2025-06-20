#!/bin/bash

echo "🚀 Setting up Jenkins on CentOS/RHEL VPS..."

# Update system
echo "📦 Updating system packages..."
sudo yum update -y

# Install Java
echo "☕ Installing Java..."
sudo yum install -y java-17-openjdk-devel

# Verify Java installation
java -version

# Add Jenkins repository
echo "📥 Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
echo "📦 Installing Jenkins..."
sudo yum install -y jenkins

# Start and enable Jenkins
echo "🔄 Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Configure firewall (if using firewalld)
echo "🔥 Configuring firewall..."
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

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