#!/bin/bash

echo "🚀 Complete Jenkins VPS Setup Script"
echo "====================================="

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    echo "❌ Cannot detect OS"
    exit 1
fi

echo "📋 Detected OS: $OS $VER"

# Function to install on Ubuntu/Debian
install_ubuntu() {
    echo "📦 Installing on Ubuntu/Debian..."
    
    # Update system
    sudo apt update && sudo apt upgrade -y
    
    # Install dependencies
    sudo apt install -y curl wget git docker.io docker-compose nginx
    
    # Install Java
    sudo apt install -y openjdk-17-jdk
    
    # Add Jenkins repository
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    sudo apt update
    sudo apt install -y jenkins
    
    # Start services
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    # Add jenkins user to docker group
    sudo usermod -aG docker jenkins
}

# Function to install on CentOS/RHEL
install_centos() {
    echo "📦 Installing on CentOS/RHEL..."
    
    # Update system
    sudo yum update -y
    
    # Install dependencies
    sudo yum install -y curl wget git docker docker-compose nginx
    
    # Install Java
    sudo yum install -y java-17-openjdk-devel
    
    # Add Jenkins repository
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    
    sudo yum install -y jenkins
    
    # Start services
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    # Configure firewall
    sudo firewall-cmd --permanent --add-port=8080/tcp
    sudo firewall-cmd --permanent --add-port=80/tcp
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --reload
    
    # Add jenkins user to docker group
    sudo usermod -aG docker jenkins
}

# Install based on OS
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
    install_ubuntu
elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
    install_centos
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

# Wait for Jenkins to start
echo "⏳ Waiting for Jenkins to start..."
sleep 60

# Get admin password
echo "🔑 Getting admin password..."
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
    echo "Admin password: $ADMIN_PASSWORD"
else
    echo "⚠️  Admin password file not found yet. Please wait and check manually:"
    echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
fi

# Get VPS IP
VPS_IP=$(curl -s ifconfig.me)

echo ""
echo "✅ Jenkins VPS Setup Completed!"
echo "================================="
echo "🌐 Access Jenkins at: http://$VPS_IP:8080"
echo "🔑 Admin password: $ADMIN_PASSWORD"
echo ""
echo "📋 Next steps:"
echo "1. Open http://$VPS_IP:8080 in your browser"
echo "2. Enter the admin password above"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Setup pipeline job"
echo ""
echo "🔧 Useful commands:"
echo "  Check Jenkins status: sudo systemctl status jenkins"
echo "  View Jenkins logs: sudo journalctl -u jenkins -f"
echo "  Restart Jenkins: sudo systemctl restart jenkins"
echo "  Check Docker: sudo systemctl status docker"
echo "  Check Nginx: sudo systemctl status nginx"
echo ""
echo "🔒 Security recommendations:"
echo "1. Change default admin password"
echo "2. Setup SSL certificate"
echo "3. Configure firewall rules"
echo "4. Setup backup strategy" 