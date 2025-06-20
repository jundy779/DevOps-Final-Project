#!/bin/bash

# 🚀 SCRIPT JALANKAN APLIKASI - Voting App DevOps Project
# Script sederhana untuk menjalankan aplikasi dengan mudah

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
    print_color "║                   SCRIPT JALANKAN APLIKASI                 ║" "$CYAN"
    print_color "╚══════════════════════════════════════════════════════════════╝" "$CYAN"
    echo ""
}

# Function to show help
show_help() {
    show_header
    print_color "CARA PENGGUNAAN SCRIPT:" "$YELLOW"
    echo ""
    echo "  ./jalankan-aplikasi.sh              # Tampilkan menu pilihan"
    echo "  ./jalankan-aplikasi.sh --docker     # Jalankan dengan Docker Compose"
    echo "  ./jalankan-aplikasi.sh --k8s        # Deploy ke Kubernetes"
    echo "  ./jalankan-aplikasi.sh --jenkins    # Jalankan Jenkins"
    echo "  ./jalankan-aplikasi.sh --monitoring # Jalankan Monitoring"
    echo "  ./jalankan-aplikasi.sh --stop       # Stop semua aplikasi"
    echo "  ./jalankan-aplikasi.sh --help       # Tampilkan bantuan ini"
    echo ""
    print_color "PILIHAN YANG TERSEDIA:" "$YELLOW"
    echo "  1. 🐳 Docker Compose (Paling Mudah)"
    echo "  2. ☸️  Kubernetes (Production-like)"
    echo "  3. 🔧 Jenkins CI/CD"
    echo "  4. 📊 Monitoring (Prometheus + Grafana)"
    echo "  5. 🛑 Stop Semua"
    echo ""
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run Docker Compose
start_docker_compose() {
    print_color "🐳 Menjalankan aplikasi dengan Docker Compose..." "$CYAN"
    
    if ! command_exists docker; then
        print_color "❌ Docker tidak ditemukan. Install Docker terlebih dahulu." "$RED"
        return 1
    fi
    
    if [[ ! -f "docker-compose.yml" ]]; then
        print_color "❌ File docker-compose.yml tidak ditemukan." "$RED"
        return 1
    fi
    
    print_color "📦 Starting containers..." "$YELLOW"
    docker-compose up -d
    
    print_color "⏳ Menunggu aplikasi siap..." "$YELLOW"
    sleep 15
    
    # Test aplikasi
    if curl -s http://localhost:8000/health > /dev/null; then
        print_color "✅ Backend berjalan dengan baik!" "$GREEN"
    else
        print_color "⚠️  Backend mungkin belum siap" "$YELLOW"
    fi
    
    if curl -s http://localhost:3000 > /dev/null; then
        print_color "✅ Frontend berjalan dengan baik!" "$GREEN"
    else
        print_color "⚠️  Frontend mungkin belum siap" "$YELLOW"
    fi
    
    print_color "✅ Aplikasi berhasil dijalankan!" "$GREEN"
    echo ""
    print_color "🌐 AKSES APLIKASI:" "$YELLOW"
    echo "   Frontend: http://localhost:3000"
    echo "   Backend API: http://localhost:8000"
    echo "   Database: localhost:5432"
    echo ""
    print_color "📊 TEST API:" "$YELLOW"
    echo "   curl http://localhost:8000/health"
    echo "   curl http://localhost:8000/api/votes"
    echo ""
    print_color "🛑 UNTUK STOP: docker-compose down" "$BLUE"
    
    return 0
}

# Function to deploy to Kubernetes
start_kubernetes() {
    print_color "☸️  Deploying ke Kubernetes..." "$CYAN"
    
    if ! command_exists kubectl; then
        print_color "❌ kubectl tidak ditemukan. Install kubectl terlebih dahulu." "$RED"
        return 1
    fi
    
    if [[ ! -d "kubernetes" ]]; then
        print_color "❌ Folder kubernetes tidak ditemukan." "$RED"
        return 1
    fi
    
    cd kubernetes
    
    if [[ -f "deploy.sh" ]]; then
        print_color "📦 Running deploy script..." "$YELLOW"
        chmod +x deploy.sh
        ./deploy.sh
    else
        print_color "📦 Deploying manually..." "$YELLOW"
        kubectl apply -f namespace.yaml
        kubectl apply -f secret.yaml
        kubectl apply -f postgres-deployment.yaml
        kubectl apply -f postgres-service.yaml
        kubectl apply -f postgres-pvc.yaml
        kubectl apply -f backend-deployment.yaml
        kubectl apply -f backend-service.yaml
        kubectl apply -f frontend-deployment.yaml
        kubectl apply -f frontend-service.yaml
    fi
    
    print_color "⏳ Menunggu deployment selesai..." "$YELLOW"
    sleep 30
    
    # Cek status
    kubectl get pods -n voting-app
    kubectl get services -n voting-app
    
    print_color "✅ Deployment berhasil!" "$GREEN"
    echo ""
    print_color "🌐 AKSES APLIKASI:" "$YELLOW"
    echo "   Port forward frontend: kubectl port-forward service/frontend-service 3000:80 -n voting-app"
    echo "   Port forward backend: kubectl port-forward service/backend-service 8000:8000 -n voting-app"
    echo ""
    print_color "🛑 UNTUK UNDEPLOY: cd kubernetes && ./undeploy.sh" "$BLUE"
    
    cd ..
    return 0
}

# Function to run Jenkins
start_jenkins() {
    print_color "🔧 Menjalankan Jenkins..." "$CYAN"
    
    if ! command_exists java; then
        print_color "❌ Java tidak ditemukan. Install Java terlebih dahulu." "$RED"
        return 1
    fi
    
    local jenkins_path="$HOME/jenkins/jenkins.war"
    if [[ ! -f "$jenkins_path" ]]; then
        print_color "❌ Jenkins tidak ditemukan di $jenkins_path" "$RED"
        print_color "   Jalankan setup script terlebih dahulu." "$YELLOW"
        return 1
    fi
    
    print_color "🚀 Starting Jenkins..." "$YELLOW"
    cd "$HOME/jenkins"
    nohup java -jar jenkins.war --httpPort=8080 > jenkins.log 2>&1 &
    local jenkins_pid=$!
    
    print_color "⏳ Menunggu Jenkins siap..." "$YELLOW"
    sleep 10
    
    print_color "✅ Jenkins berhasil dijalankan! (PID: $jenkins_pid)" "$GREEN"
    echo ""
    print_color "🌐 AKSES JENKINS:" "$YELLOW"
    echo "   URL: http://localhost:8080"
    echo ""
    print_color "🔑 PASSWORD PERTAMA KALI:" "$YELLOW"
    echo "   Cek file: $HOME/.jenkins/secrets/initialAdminPassword"
    echo ""
    print_color "📋 LOGS: $HOME/jenkins/jenkins.log" "$BLUE"
    print_color "🛑 UNTUK STOP: kill $jenkins_pid" "$BLUE"
    
    cd - > /dev/null
    return 0
}

# Function to run Monitoring
start_monitoring() {
    print_color "📊 Menjalankan Monitoring..." "$CYAN"
    
    if ! command_exists docker; then
        print_color "❌ Docker tidak ditemukan. Install Docker terlebih dahulu." "$RED"
        return 1
    fi
    
    if [[ ! -d "monitoring" ]]; then
        print_color "❌ Folder monitoring tidak ditemukan." "$RED"
        return 1
    fi
    
    cd monitoring
    
    if [[ -f "docker-compose.yml" ]]; then
        print_color "📦 Starting monitoring stack..." "$YELLOW"
        docker-compose up -d
        
        print_color "⏳ Menunggu monitoring siap..." "$YELLOW"
        sleep 20
        
        print_color "✅ Monitoring berhasil dijalankan!" "$GREEN"
        echo ""
        print_color "🌐 AKSES MONITORING:" "$YELLOW"
        echo "   Grafana: http://localhost:3001"
        echo "   Username: admin"
        echo "   Password: admin"
        echo ""
        echo "   Prometheus: http://localhost:9090"
        echo ""
        print_color "🛑 UNTUK STOP: cd monitoring && docker-compose down" "$BLUE"
    else
        print_color "❌ File docker-compose.yml tidak ditemukan di folder monitoring." "$RED"
    fi
    
    cd ..
    return 0
}

# Function to stop all applications
stop_all_applications() {
    print_color "🛑 Stopping semua aplikasi..." "$CYAN"
    
    # Stop Docker Compose
    if [[ -f "docker-compose.yml" ]]; then
        print_color "🐳 Stopping Docker Compose..." "$YELLOW"
        docker-compose down
    fi
    
    # Stop Kubernetes
    if command_exists kubectl; then
        print_color "☸️  Stopping Kubernetes deployment..." "$YELLOW"
        if [[ -d "kubernetes" ]]; then
            cd kubernetes
            if [[ -f "undeploy.sh" ]]; then
                chmod +x undeploy.sh
                ./undeploy.sh
            else
                kubectl delete namespace voting-app --ignore-not-found=true
            fi
            cd ..
        fi
    fi
    
    # Stop Monitoring
    if [[ -d "monitoring" ]]; then
        print_color "📊 Stopping monitoring..." "$YELLOW"
        cd monitoring
        if [[ -f "docker-compose.yml" ]]; then
            docker-compose down
        fi
        cd ..
    fi
    
    # Stop Jenkins
    print_color "🔧 Stopping Jenkins..." "$YELLOW"
    pkill -f "jenkins.war"
    
    print_color "✅ Semua aplikasi berhasil dihentikan!" "$GREEN"
    return 0
}

# Function to show menu
show_menu() {
    show_header
    print_color "PILIH CARA MENJALANKAN APLIKASI:" "$YELLOW"
    echo ""
    echo "1. 🐳 Docker Compose (Paling Mudah)"
    echo "2. ☸️  Kubernetes (Production-like)"
    echo "3. 🔧 Jenkins CI/CD"
    echo "4. 📊 Monitoring (Prometheus + Grafana)"
    echo "5. 🛑 Stop Semua Aplikasi"
    echo "6. ❌ Keluar"
    echo ""
    
    read -p "Masukkan pilihan (1-6): " choice
    
    case $choice in
        1) start_docker_compose ;;
        2) start_kubernetes ;;
        3) start_jenkins ;;
        4) start_monitoring ;;
        5) stop_all_applications ;;
        6) 
            print_color "👋 Sampai jumpa!" "$GREEN"
            exit 0 
            ;;
        *) 
            print_color "❌ Pilihan tidak valid!" "$RED"
            sleep 2
            show_menu
            ;;
    esac
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --docker)
            start_docker_compose
            exit $?
            ;;
        --k8s)
            start_kubernetes
            exit $?
            ;;
        --jenkins)
            start_jenkins
            exit $?
            ;;
        --monitoring)
            start_monitoring
            exit $?
            ;;
        --stop)
            stop_all_applications
            exit $?
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
    shift
done

# Show interactive menu if no arguments provided
show_menu

echo ""
print_color "Tekan Enter untuk keluar..." "$BLUE"
read 