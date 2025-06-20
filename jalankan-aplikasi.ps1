# 🚀 SCRIPT JALANKAN APLIKASI - Voting App DevOps Project
# Script sederhana untuk menjalankan aplikasi dengan mudah

param(
    [switch]$Docker,
    [switch]$Kubernetes,
    [switch]$Jenkins,
    [switch]$Monitoring,
    [switch]$Stop,
    [switch]$Help
)

# Fungsi untuk menampilkan pesan dengan warna
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Fungsi untuk menampilkan header
function Show-Header {
    Clear-Host
    Write-ColorOutput "╔══════════════════════════════════════════════════════════════╗" "Cyan"
    Write-ColorOutput "║                    VOTING APP DEVOPS PROJECT                ║" "Cyan"
    Write-ColorOutput "║                   SCRIPT JALANKAN APLIKASI                 ║" "Cyan"
    Write-ColorOutput "╚══════════════════════════════════════════════════════════════╝" "Cyan"
    Write-Host ""
}

# Fungsi untuk menampilkan help
function Show-Help {
    Show-Header
    Write-ColorOutput "CARA PENGGUNAAN SCRIPT:" "Yellow"
    Write-Host ""
    Write-Host "  .\jalankan-aplikasi.ps1              # Tampilkan menu pilihan"
    Write-Host "  .\jalankan-aplikasi.ps1 -Docker      # Jalankan dengan Docker Compose"
    Write-Host "  .\jalankan-aplikasi.ps1 -Kubernetes  # Deploy ke Kubernetes"
    Write-Host "  .\jalankan-aplikasi.ps1 -Jenkins     # Jalankan Jenkins"
    Write-Host "  .\jalankan-aplikasi.ps1 -Monitoring  # Jalankan Monitoring"
    Write-Host "  .\jalankan-aplikasi.ps1 -Stop        # Stop semua aplikasi"
    Write-Host "  .\jalankan-aplikasi.ps1 -Help        # Tampilkan bantuan ini"
    Write-Host ""
    Write-ColorOutput "PILIHAN YANG TERSEDIA:" "Yellow"
    Write-Host "  1. 🐳 Docker Compose (Paling Mudah)"
    Write-Host "  2. ☸️  Kubernetes (Production-like)"
    Write-Host "  3. 🔧 Jenkins CI/CD"
    Write-Host "  4. 📊 Monitoring (Prometheus + Grafana)"
    Write-Host "  5. 🛑 Stop Semua"
    Write-Host ""
}

# Fungsi untuk cek apakah command tersedia
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Fungsi untuk jalankan Docker Compose
function Start-DockerCompose {
    Write-ColorOutput "🐳 Menjalankan aplikasi dengan Docker Compose..." "Cyan"
    
    if (-not (Test-Command "docker")) {
        Write-ColorOutput "❌ Docker tidak ditemukan. Install Docker terlebih dahulu." "Red"
        return $false
    }
    
    if (-not (Test-Path "docker-compose.yml")) {
        Write-ColorOutput "❌ File docker-compose.yml tidak ditemukan." "Red"
        return $false
    }
    
    try {
        Write-ColorOutput "📦 Starting containers..." "Yellow"
        docker-compose up -d
        
        Write-ColorOutput "⏳ Menunggu aplikasi siap..." "Yellow"
        Start-Sleep -Seconds 15
        
        # Test aplikasi
        $backendResponse = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing -ErrorAction SilentlyContinue
        $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -ErrorAction SilentlyContinue
        
        Write-ColorOutput "✅ Aplikasi berhasil dijalankan!" "Green"
        Write-Host ""
        Write-ColorOutput "🌐 AKSES APLIKASI:" "Yellow"
        Write-Host "   Frontend: http://localhost:3000"
        Write-Host "   Backend API: http://localhost:8000"
        Write-Host "   Database: localhost:5432"
        Write-Host ""
        Write-ColorOutput "📊 TEST API:" "Yellow"
        Write-Host "   curl http://localhost:8000/health"
        Write-Host "   curl http://localhost:8000/api/votes"
        Write-Host ""
        Write-ColorOutput "🛑 UNTUK STOP: docker-compose down" "Gray"
        
        return $true
    }
    catch {
        Write-ColorOutput "❌ Error menjalankan Docker Compose: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fungsi untuk deploy ke Kubernetes
function Start-Kubernetes {
    Write-ColorOutput "☸️  Deploying ke Kubernetes..." "Cyan"
    
    if (-not (Test-Command "kubectl")) {
        Write-ColorOutput "❌ kubectl tidak ditemukan. Install kubectl terlebih dahulu." "Red"
        return $false
    }
    
    if (-not (Test-Path "kubernetes")) {
        Write-ColorOutput "❌ Folder kubernetes tidak ditemukan." "Red"
        return $false
    }
    
    try {
        Set-Location kubernetes
        
        if (Test-Path "deploy.sh") {
            Write-ColorOutput "📦 Running deploy script..." "Yellow"
            if ($IsWindows) {
                bash deploy.sh
            } else {
                chmod +x deploy.sh
                ./deploy.sh
            }
        } else {
            Write-ColorOutput "📦 Deploying manually..." "Yellow"
            kubectl apply -f namespace.yaml
            kubectl apply -f secret.yaml
            kubectl apply -f postgres-deployment.yaml
            kubectl apply -f postgres-service.yaml
            kubectl apply -f postgres-pvc.yaml
            kubectl apply -f backend-deployment.yaml
            kubectl apply -f backend-service.yaml
            kubectl apply -f frontend-deployment.yaml
            kubectl apply -f frontend-service.yaml
        }
        
        Write-ColorOutput "⏳ Menunggu deployment selesai..." "Yellow"
        Start-Sleep -Seconds 30
        
        # Cek status
        kubectl get pods -n voting-app
        kubectl get services -n voting-app
        
        Write-ColorOutput "✅ Deployment berhasil!" "Green"
        Write-Host ""
        Write-ColorOutput "🌐 AKSES APLIKASI:" "Yellow"
        Write-Host "   Port forward frontend: kubectl port-forward service/frontend-service 3000:80 -n voting-app"
        Write-Host "   Port forward backend: kubectl port-forward service/backend-service 8000:8000 -n voting-app"
        Write-Host ""
        Write-ColorOutput "🛑 UNTUK UNDEPLOY: cd kubernetes && ./undeploy.sh" "Gray"
        
        Set-Location ..
        return $true
    }
    catch {
        Write-ColorOutput "❌ Error deploying ke Kubernetes: $($_.Exception.Message)" "Red"
        Set-Location ..
        return $false
    }
}

# Fungsi untuk jalankan Jenkins
function Start-Jenkins {
    Write-ColorOutput "🔧 Menjalankan Jenkins..." "Cyan"
    
    if (-not (Test-Command "java")) {
        Write-ColorOutput "❌ Java tidak ditemukan. Install Java terlebih dahulu." "Red"
        return $false
    }
    
    $jenkinsPath = "C:\jenkins\jenkins.war"
    if (-not (Test-Path $jenkinsPath)) {
        Write-ColorOutput "❌ Jenkins tidak ditemukan di $jenkinsPath" "Red"
        Write-ColorOutput "   Jalankan setup script terlebih dahulu." "Yellow"
        return $false
    }
    
    try {
        Write-ColorOutput "🚀 Starting Jenkins..." "Yellow"
        Start-Process -FilePath "java" -ArgumentList "-jar", $jenkinsPath, "--httpPort=8080" -WindowStyle Minimized
        
        Write-ColorOutput "⏳ Menunggu Jenkins siap..." "Yellow"
        Start-Sleep -Seconds 10
        
        Write-ColorOutput "✅ Jenkins berhasil dijalankan!" "Green"
        Write-Host ""
        Write-ColorOutput "🌐 AKSES JENKINS:" "Yellow"
        Write-Host "   URL: http://localhost:8080"
        Write-Host ""
        Write-ColorOutput "🔑 PASSWORD PERTAMA KALI:" "Yellow"
        Write-Host "   Cek file: C:\Users\$env:USERNAME\.jenkins\secrets\initialAdminPassword"
        Write-Host ""
        Write-ColorOutput "🛑 UNTUK STOP: Tutup terminal atau kill process Java" "Gray"
        
        return $true
    }
    catch {
        Write-ColorOutput "❌ Error menjalankan Jenkins: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fungsi untuk jalankan Monitoring
function Start-Monitoring {
    Write-ColorOutput "📊 Menjalankan Monitoring..." "Cyan"
    
    if (-not (Test-Command "docker")) {
        Write-ColorOutput "❌ Docker tidak ditemukan. Install Docker terlebih dahulu." "Red"
        return $false
    }
    
    if (-not (Test-Path "monitoring")) {
        Write-ColorOutput "❌ Folder monitoring tidak ditemukan." "Red"
        return $false
    }
    
    try {
        Set-Location monitoring
        
        if (Test-Path "docker-compose.yml") {
            Write-ColorOutput "📦 Starting monitoring stack..." "Yellow"
            docker-compose up -d
            
            Write-ColorOutput "⏳ Menunggu monitoring siap..." "Yellow"
            Start-Sleep -Seconds 20
            
            Write-ColorOutput "✅ Monitoring berhasil dijalankan!" "Green"
            Write-Host ""
            Write-ColorOutput "🌐 AKSES MONITORING:" "Yellow"
            Write-Host "   Grafana: http://localhost:3001"
            Write-Host "   Username: admin"
            Write-Host "   Password: admin"
            Write-Host ""
            Write-Host "   Prometheus: http://localhost:9090"
            Write-Host ""
            Write-ColorOutput "🛑 UNTUK STOP: cd monitoring && docker-compose down" "Gray"
        } else {
            Write-ColorOutput "❌ File docker-compose.yml tidak ditemukan di folder monitoring." "Red"
        }
        
        Set-Location ..
        return $true
    }
    catch {
        Write-ColorOutput "❌ Error menjalankan monitoring: $($_.Exception.Message)" "Red"
        Set-Location ..
        return $false
    }
}

# Fungsi untuk stop semua aplikasi
function Stop-AllApplications {
    Write-ColorOutput "🛑 Stopping semua aplikasi..." "Cyan"
    
    try {
        # Stop Docker Compose
        if (Test-Path "docker-compose.yml") {
            Write-ColorOutput "🐳 Stopping Docker Compose..." "Yellow"
            docker-compose down
        }
        
        # Stop Kubernetes
        if (Test-Command "kubectl") {
            Write-ColorOutput "☸️  Stopping Kubernetes deployment..." "Yellow"
            if (Test-Path "kubernetes") {
                Set-Location kubernetes
                if (Test-Path "undeploy.sh") {
                    if ($IsWindows) {
                        bash undeploy.sh
                    } else {
                        chmod +x undeploy.sh
                        ./undeploy.sh
                    }
                } else {
                    kubectl delete namespace voting-app --ignore-not-found=true
                }
                Set-Location ..
            }
        }
        
        # Stop Monitoring
        if (Test-Path "monitoring") {
            Write-ColorOutput "📊 Stopping monitoring..." "Yellow"
            Set-Location monitoring
            if (Test-Path "docker-compose.yml") {
                docker-compose down
            }
            Set-Location ..
        }
        
        # Stop Jenkins (kill Java processes)
        Write-ColorOutput "🔧 Stopping Jenkins..." "Yellow"
        Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
        
        Write-ColorOutput "✅ Semua aplikasi berhasil dihentikan!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "❌ Error stopping aplikasi: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fungsi untuk tampilkan menu
function Show-Menu {
    Show-Header
    Write-ColorOutput "PILIH CARA MENJALANKAN APLIKASI:" "Yellow"
    Write-Host ""
    Write-Host "1. 🐳 Docker Compose (Paling Mudah)"
    Write-Host "2. ☸️  Kubernetes (Production-like)"
    Write-Host "3. 🔧 Jenkins CI/CD"
    Write-Host "4. 📊 Monitoring (Prometheus + Grafana)"
    Write-Host "5. 🛑 Stop Semua Aplikasi"
    Write-Host "6. ❌ Keluar"
    Write-Host ""
    
    $choice = Read-Host "Masukkan pilihan (1-6)"
    
    switch ($choice) {
        "1" { Start-DockerCompose }
        "2" { Start-Kubernetes }
        "3" { Start-Jenkins }
        "4" { Start-Monitoring }
        "5" { Stop-AllApplications }
        "6" { 
            Write-ColorOutput "👋 Sampai jumpa!" "Green"
            exit 0 
        }
        default { 
            Write-ColorOutput "❌ Pilihan tidak valid!" "Red"
            Start-Sleep -Seconds 2
            Show-Menu
        }
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

# Check if specific option is provided
if ($Docker) {
    Start-DockerCompose
}
elseif ($Kubernetes) {
    Start-Kubernetes
}
elseif ($Jenkins) {
    Start-Jenkins
}
elseif ($Monitoring) {
    Start-Monitoring
}
elseif ($Stop) {
    Stop-AllApplications
}
else {
    # Show interactive menu
    Show-Menu
}

Write-Host ""
Write-ColorOutput "Tekan Enter untuk keluar..." "Gray"
Read-Host 