#!/bin/bash

# 🚀 SCRIPT SETUP LENGKAP UNTUK AWAM - Voting App DevOps Project
# Script ini akan membantu Anda setup semua yang diperlukan untuk menjalankan proyek ini

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    echo -e "${2}${1}${NC}"
}

# Function to show header
show_header() {
    clear
    print_color "╔══════════════════════════════════════════════════════════════╗" "$CYAN"
    print_color "║                    VOTING APP DEVOPS PROJECT                ║" "$CYAN"
    print_color "║                     SETUP SCRIPT UNTUK AWAM                 ║" "$CYAN"
    print_color "╚══════════════════════════════════════════════════════════════╝" "$CYAN"
    echo ""
}

# Function to show help
show_help() {
    show_header
    print_color "CARA PENGGUNAAN SCRIPT:" "$YELLOW"
    echo ""
    echo "  ./setup-untuk-awam.sh                    # Setup semua komponen"
    echo "  ./setup-untuk-awam.sh --skip-docker      # Skip instalasi Docker"
    echo "  ./setup-untuk-awam.sh --skip-k8s         # Skip setup Kubernetes"
    echo "  ./setup-untuk-awam.sh --skip-jenkins     # Skip setup Jenkins"
    echo "  ./setup-untuk-awam.sh --skip-monitoring  # Skip setup Monitoring"
    echo "  ./setup-untuk-awam.sh --help             # Tampilkan bantuan ini"
    echo ""
    print_color "KOMPONEN YANG AKAN DIINSTALL:" "$YELLOW"
    echo "  ✓ Docker & Docker Compose"
    echo "  ✓ kubectl (Kubernetes CLI)"
    echo "  ✓ minikube (Local Kubernetes)"
    echo "  ✓ Git"
    echo "  ✓ Jenkins"
    echo "  ✓ Monitoring (Prometheus + Grafana)"
    echo ""
    print_color "WAKTU ESTIMASI: 15-30 menit" "$GREEN"
    echo ""
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "ubuntu"
        elif command_exists yum; then
            echo "centos"
        elif command_exists dnf; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to install Docker
install_docker() {
    local os=$(detect_os)
    
    print_color "🐳 Setting up Docker..." "$CYAN"
    
    if command_exists docker; then
        print_color "✅ Docker sudah terinstall!" "$GREEN"
        return 0
    fi
    
    case $os in
        "ubuntu")
            print_color "📦 Installing Docker on Ubuntu..." "$YELLOW"
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo usermod -aG docker $USER
            ;;
        "centos")
            print_color "📦 Installing Docker on CentOS..." "$YELLOW"
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            ;;
        "macos")
            print_color "📦 Installing Docker Desktop on macOS..." "$YELLOW"
            if command_exists brew; then
                brew install --cask docker
            else
                print_color "❌ Homebrew tidak ditemukan. Install Homebrew terlebih dahulu." "$RED"
                return 1
            fi
            ;;
        *)
            print_color "❌ OS tidak didukung untuk auto-install Docker" "$RED"
            print_color "   Silakan install Docker manual dari https://docs.docker.com/get-docker/" "$YELLOW"
            return 1
            ;;
    esac
    
    if command_exists docker; then
        print_color "✅ Docker berhasil diinstall!" "$GREEN"
        return 0
    else
        print_color "❌ Gagal install Docker" "$RED"
        return 1
    fi
}

# Function to install kubectl
install_kubectl() {
    print_color "📦 Installing kubectl..." "$YELLOW"
    
    if command_exists kubectl; then
        print_color "✅ kubectl sudah terinstall!" "$GREEN"
        return 0
    fi
    
    local os=$(detect_os)
    case $os in
        "ubuntu"|"centos")
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            ;;
        "macos")
            if command_exists brew; then
                brew install kubectl
            else
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                rm kubectl
            fi
            ;;
    esac
    
    if command_exists kubectl; then
        print_color "✅ kubectl berhasil diinstall!" "$GREEN"
        return 0
    else
        print_color "❌ Gagal install kubectl" "$RED"
        return 1
    fi
}

# Function to install minikube
install_minikube() {
    print_color "📦 Installing minikube..." "$YELLOW"
    
    if command_exists minikube; then
        print_color "✅ minikube sudah terinstall!" "$GREEN"
        return 0
    fi
    
    local os=$(detect_os)
    case $os in
        "ubuntu"|"centos")
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            ;;
        "macos")
            if command_exists brew; then
                brew install minikube
            else
                curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
                sudo install minikube-darwin-amd64 /usr/local/bin/minikube
                rm minikube-darwin-amd64
            fi
            ;;
    esac
    
    if command_exists minikube; then
        print_color "✅ minikube berhasil diinstall!" "$GREEN"
        return 0
    else
        print_color "❌ Gagal install minikube" "$RED"
        return 1
    fi
}

# Function to setup Kubernetes
setup_kubernetes() {
    if [[ "$SKIP_K8S" == "true" ]]; then
        print_color "⏭️  Skipping Kubernetes setup..." "$YELLOW"
        return 0
    fi
    
    print_color "☸️  Setting up Kubernetes..." "$CYAN"
    
    # Install kubectl and minikube
    if ! install_kubectl; then
        return 1
    fi
    
    if ! install_minikube; then
        return 1
    fi
    
    # Start minikube
    print_color "🚀 Starting minikube cluster..." "$YELLOW"
    if minikube start --driver=docker; then
        minikube addons enable ingress
        minikube addons enable metrics-server
        print_color "✅ Kubernetes cluster siap!" "$GREEN"
        return 0
    else
        print_color "❌ Gagal start minikube" "$RED"
        return 1
    fi
}

# Function to install Git
install_git() {
    print_color "📝 Setting up Git..." "$CYAN"
    
    if command_exists git; then
        print_color "✅ Git sudah terinstall!" "$GREEN"
    else
        local os=$(detect_os)
        case $os in
            "ubuntu")
                sudo apt-get update && sudo apt-get install -y git
                ;;
            "centos")
                sudo yum install -y git
                ;;
            "macos")
                if command_exists brew; then
                    brew install git
                else
                    print_color "❌ Homebrew tidak ditemukan" "$RED"
                    return 1
                fi
                ;;
        esac
    fi
    
    # Setup Git config
    read -p "Masukkan nama Anda untuk Git (atau tekan Enter untuk skip): " git_name
    if [[ -n "$git_name" ]]; then
        git config --global user.name "$git_name"
    fi
    
    read -p "Masukkan email Anda untuk Git (atau tekan Enter untuk skip): " git_email
    if [[ -n "$git_email" ]]; then
        git config --global user.email "$git_email"
    fi
    
    return 0
}

# Function to setup Jenkins
setup_jenkins() {
    if [[ "$SKIP_JENKINS" == "true" ]]; then
        print_color "⏭️  Skipping Jenkins setup..." "$YELLOW"
        return 0
    fi
    
    print_color "🔧 Setting up Jenkins..." "$CYAN"
    
    # Check if Java is installed
    if ! command_exists java; then
        print_color "📦 Installing Java..." "$YELLOW"
        local os=$(detect_os)
        case $os in
            "ubuntu")
                sudo apt-get update && sudo apt-get install -y openjdk-11-jdk
                ;;
            "centos")
                sudo yum install -y java-11-openjdk-devel
                ;;
            "macos")
                if command_exists brew; then
                    brew install openjdk@11
                else
                    print_color "❌ Homebrew tidak ditemukan" "$RED"
                    return 1
                fi
                ;;
        esac
    fi
    
    # Create Jenkins directory
    local jenkins_dir="$HOME/jenkins"
    mkdir -p "$jenkins_dir"
    
    # Download Jenkins
    local jenkins_url="https://get.jenkins.io/war-stable/latest/jenkins.war"
    local jenkins_path="$jenkins_dir/jenkins.war"
    
    if [[ ! -f "$jenkins_path" ]]; then
        print_color "📥 Downloading Jenkins..." "$YELLOW"
        if curl -L "$jenkins_url" -o "$jenkins_path"; then
            print_color "✅ Jenkins downloaded!" "$GREEN"
        else
            print_color "❌ Gagal download Jenkins" "$RED"
            return 1
        fi
    fi
    
    # Create Jenkins startup script
    cat > "$jenkins_dir/start-jenkins.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
java -jar jenkins.war --httpPort=8080
EOF
    chmod +x "$jenkins_dir/start-jenkins.sh"
    
    print_color "✅ Jenkins setup selesai!" "$GREEN"
    print_color "   Untuk menjalankan Jenkins: $jenkins_dir/start-jenkins.sh" "$YELLOW"
    print_color "   Atau jalankan: java -jar $jenkins_path --httpPort=8080" "$YELLOW"
    
    return 0
}

# Function to setup monitoring
setup_monitoring() {
    if [[ "$SKIP_MONITORING" == "true" ]]; then
        print_color "⏭️  Skipping Monitoring setup..." "$YELLOW"
        return 0
    fi
    
    print_color "📊 Setting up Monitoring..." "$CYAN"
    
    if [[ -d "monitoring" ]]; then
        print_color "📁 Monitoring files sudah ada!" "$GREEN"
        return 0
    else
        print_color "❌ Folder monitoring tidak ditemukan" "$RED"
        return 1
    fi
}

# Function to test application
test_application() {
    print_color "🧪 Testing aplikasi..." "$CYAN"
    
    if [[ -f "docker-compose.yml" ]]; then
        print_color "📦 Testing Docker Compose..." "$YELLOW"
        
        # Start application
        docker-compose up -d
        
        # Wait for services to start
        sleep 15
        
        # Test backend
        if curl -s http://localhost:8000/health > /dev/null; then
            print_color "✅ Backend berjalan dengan baik!" "$GREEN"
        else
            print_color "⚠️  Backend mungkin belum siap" "$YELLOW"
        fi
        
        # Test frontend
        if curl -s http://localhost:3000 > /dev/null; then
            print_color "✅ Frontend berjalan dengan baik!" "$GREEN"
        else
            print_color "⚠️  Frontend mungkin belum siap" "$YELLOW"
        fi
        
        # Stop application
        docker-compose down
    else
        print_color "❌ docker-compose.yml tidak ditemukan" "$RED"
    fi
}

# Function to show next steps
show_next_steps() {
    print_color "🎉 SETUP SELESAI!" "$GREEN"
    echo ""
    print_color "LANGKAH SELANJUTNYA:" "$YELLOW"
    echo ""
    echo "1. 🐳 DOCKER COMPOSE (Paling Mudah):"
    echo "   docker-compose up -d"
    echo "   Buka: http://localhost:3000"
    echo ""
    echo "2. ☸️  KUBERNETES:"
    echo "   cd kubernetes"
    echo "   chmod +x deploy.sh"
    echo "   ./deploy.sh"
    echo ""
    echo "3. 🔧 JENKINS:"
    echo "   ~/jenkins/start-jenkins.sh"
    echo "   Buka: http://localhost:8080"
    echo ""
    echo "4. 📊 MONITORING:"
    echo "   cd monitoring"
    echo "   docker-compose up -d"
    echo "   Buka: http://localhost:3001 (Grafana)"
    echo ""
    print_color "📚 BACA PANDUAN LENGKAP:" "$YELLOW"
    echo "   docs/PANDUAN_LENGKAP_UNTUK_AWAM.md"
    echo ""
    print_color "🆘 BUTUH BANTUAN?" "$YELLOW"
    echo "   - Cek troubleshooting di panduan"
    echo "   - Google error message"
    echo "   - Tanya di forum Stack Overflow"
    echo ""
}

# Parse command line arguments
SKIP_DOCKER=false
SKIP_K8S=false
SKIP_JENKINS=false
SKIP_MONITORING=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-docker)
            SKIP_DOCKER=true
            shift
            ;;
        --skip-k8s)
            SKIP_K8S=true
            shift
            ;;
        --skip-jenkins)
            SKIP_JENKINS=true
            shift
            ;;
        --skip-monitoring)
            SKIP_MONITORING=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            print_color "❌ Unknown option: $1" "$RED"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
show_header

print_color "🚀 MULAI SETUP VOTING APP DEVOPS PROJECT" "$GREEN"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_color "⚠️  Script ini sebaiknya tidak dijalankan sebagai root" "$YELLOW"
    print_color "   Beberapa komponen mungkin tidak berfungsi dengan baik" "$YELLOW"
    read -p "Lanjutkan? (y/n): " continue_choice
    if [[ "$continue_choice" != "y" && "$continue_choice" != "Y" ]]; then
        exit 1
    fi
fi

success=true

# Setup components
if [[ "$SKIP_DOCKER" != "true" ]]; then
    if ! install_docker; then
        success=false
    fi
fi

if ! setup_kubernetes; then
    success=false
fi

if ! install_git; then
    success=false
fi

if ! setup_jenkins; then
    success=false
fi

if ! setup_monitoring; then
    success=false
fi

# Test application
if [[ "$success" == "true" ]]; then
    test_application
fi

# Show results
echo ""
if [[ "$success" == "true" ]]; then
    show_next_steps
else
    print_color "❌ Setup tidak lengkap. Cek error di atas." "$RED"
    print_color "   Coba jalankan script lagi atau cek panduan troubleshooting." "$YELLOW"
fi

echo ""
print_color "Tekan Enter untuk keluar..." "$BLUE"
read 