# 🚀 SCRIPT SETUP LENGKAP UNTUK AWAM - Voting App DevOps Project
# Script ini akan membantu Anda setup semua yang diperlukan untuk menjalankan proyek ini

param(
    [switch]$SkipDocker,
    [switch]$SkipKubernetes,
    [switch]$SkipJenkins,
    [switch]$SkipMonitoring,
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
    Write-ColorOutput "║                     SETUP SCRIPT UNTUK AWAM                 ║" "Cyan"
    Write-ColorOutput "╚══════════════════════════════════════════════════════════════╝" "Cyan"
    Write-Host ""
}

# Fungsi untuk menampilkan help
function Show-Help {
    Show-Header
    Write-ColorOutput "CARA PENGGUNAAN SCRIPT:" "Yellow"
    Write-Host ""
    Write-Host "  .\setup-untuk-awam.ps1                    # Setup semua komponen"
    Write-Host "  .\setup-untuk-awam.ps1 -SkipDocker        # Skip instalasi Docker"
    Write-Host "  .\setup-untuk-awam.ps1 -SkipKubernetes    # Skip setup Kubernetes"
    Write-Host "  .\setup-untuk-awam.ps1 -SkipJenkins       # Skip setup Jenkins"
    Write-Host "  .\setup-untuk-awam.ps1 -SkipMonitoring    # Skip setup Monitoring"
    Write-Host "  .\setup-untuk-awam.ps1 -Help              # Tampilkan bantuan ini"
    Write-Host ""
    Write-ColorOutput "KOMPONEN YANG AKAN DIINSTALL:" "Yellow"
    Write-Host "  ✓ Docker Desktop"
    Write-Host "  ✓ kubectl (Kubernetes CLI)"
    Write-Host "  ✓ minikube (Local Kubernetes)"
    Write-Host "  ✓ Git"
    Write-Host "  ✓ Jenkins"
    Write-Host "  ✓ Monitoring (Prometheus + Grafana)"
    Write-Host ""
    Write-ColorOutput "WAKTU ESTIMASI: 15-30 menit" "Green"
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

# Fungsi untuk cek apakah Chocolatey terinstall
function Test-Chocolatey {
    return Test-Command "choco"
}

# Fungsi untuk install Chocolatey
function Install-Chocolatey {
    Write-ColorOutput "📦 Installing Chocolatey..." "Yellow"
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-ColorOutput "✅ Chocolatey berhasil diinstall!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "❌ Gagal install Chocolatey: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fungsi untuk install software menggunakan Chocolatey
function Install-Software {
    param(
        [string]$SoftwareName,
        [string]$DisplayName
    )
    Write-ColorOutput "📦 Installing $DisplayName..." "Yellow"
    try {
        choco install $SoftwareName -y
        Write-ColorOutput "✅ $DisplayName berhasil diinstall!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "❌ Gagal install $DisplayName: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Fungsi untuk setup Docker
function Setup-Docker {
    if ($SkipDocker) {
        Write-ColorOutput "⏭️  Skipping Docker setup..." "Yellow"
        return $true
    }

    Write-ColorOutput "🐳 Setting up Docker..." "Cyan"
    
    if (Test-Command "docker") {
        Write-ColorOutput "✅ Docker sudah terinstall!" "Green"
    }
    else {
        if (-not (Test-Chocolatey)) {
            if (-not (Install-Chocolatey)) {
                return $false
            }
        }
        
        if (-not (Install-Software "docker-desktop" "Docker Desktop")) {
            return $false
        }
        
        Write-ColorOutput "🔄 Restart komputer diperlukan untuk Docker Desktop" "Yellow"
        Write-ColorOutput "   Setelah restart, jalankan script ini lagi" "Yellow"
        $restart = Read-Host "Restart sekarang? (y/n)"
        if ($restart -eq "y" -or $restart -eq "Y") {
            Restart-Computer -Force
        }
        return $false
    }
    
    # Test Docker
    try {
        docker --version | Out-Null
        Write-ColorOutput "✅ Docker berfungsi dengan baik!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "❌ Docker tidak berfungsi. Pastikan Docker Desktop running" "Red"
        return $false
    }
}

# Fungsi untuk setup Kubernetes tools
function Setup-Kubernetes {
    if ($SkipKubernetes) {
        Write-ColorOutput "⏭️  Skipping Kubernetes setup..." "Yellow"
        return $true
    }

    Write-ColorOutput "☸️  Setting up Kubernetes tools..." "Cyan"
    
    $success = $true
    
    # Install kubectl
    if (Test-Command "kubectl") {
        Write-ColorOutput "✅ kubectl sudah terinstall!" "Green"
    }
    else {
        if (-not (Install-Software "kubernetes-cli" "kubectl")) {
            $success = $false
        }
    }
    
    # Install minikube
    if (Test-Command "minikube") {
        Write-ColorOutput "✅ minikube sudah terinstall!" "Green"
    }
    else {
        if (-not (Install-Software "minikube" "minikube")) {
            $success = $false
        }
    }
    
    if ($success) {
        Write-ColorOutput "🚀 Starting minikube cluster..." "Yellow"
        try {
            minikube start --driver=docker
            minikube addons enable ingress
            minikube addons enable metrics-server
            Write-ColorOutput "✅ Kubernetes cluster siap!" "Green"
        }
        catch {
            Write-ColorOutput "❌ Gagal start minikube: $($_.Exception.Message)" "Red"
            $success = $false
        }
    }
    
    return $success
}

# Fungsi untuk setup Git
function Setup-Git {
    Write-ColorOutput "📝 Setting up Git..." "Cyan"
    
    if (Test-Command "git") {
        Write-ColorOutput "✅ Git sudah terinstall!" "Green"
    }
    else {
        if (-not (Install-Software "git" "Git")) {
            return $false
        }
    }
    
    # Setup Git config
    $gitName = Read-Host "Masukkan nama Anda untuk Git (atau tekan Enter untuk skip)"
    if ($gitName) {
        git config --global user.name $gitName
    }
    
    $gitEmail = Read-Host "Masukkan email Anda untuk Git (atau tekan Enter untuk skip)"
    if ($gitEmail) {
        git config --global user.email $gitEmail
    }
    
    return $true
}

# Fungsi untuk setup Jenkins
function Setup-Jenkins {
    if ($SkipJenkins) {
        Write-ColorOutput "⏭️  Skipping Jenkins setup..." "Yellow"
        return $true
    }

    Write-ColorOutput "🔧 Setting up Jenkins..." "Cyan"
    
    # Check if Java is installed
    if (-not (Test-Command "java")) {
        Write-ColorOutput "📦 Installing Java..." "Yellow"
        if (-not (Install-Software "openjdk11" "Java 11")) {
            return $false
        }
    }
    
    # Create Jenkins directory
    $jenkinsDir = "C:\jenkins"
    if (-not (Test-Path $jenkinsDir)) {
        New-Item -ItemType Directory -Path $jenkinsDir -Force | Out-Null
    }
    
    # Download Jenkins
    $jenkinsUrl = "https://get.jenkins.io/war-stable/latest/jenkins.war"
    $jenkinsPath = "$jenkinsDir\jenkins.war"
    
    if (-not (Test-Path $jenkinsPath)) {
        Write-ColorOutput "📥 Downloading Jenkins..." "Yellow"
        try {
            Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsPath
            Write-ColorOutput "✅ Jenkins downloaded!" "Green"
        }
        catch {
            Write-ColorOutput "❌ Gagal download Jenkins: $($_.Exception.Message)" "Red"
            return $false
        }
    }
    
    # Create Jenkins startup script
    $startScript = @"
@echo off
cd /d C:\jenkins
java -jar jenkins.war --httpPort=8080
pause
"@
    
    $startScriptPath = "$jenkinsDir\start-jenkins.bat"
    $startScript | Out-File -FilePath $startScriptPath -Encoding ASCII
    
    Write-ColorOutput "✅ Jenkins setup selesai!" "Green"
    Write-ColorOutput "   Untuk menjalankan Jenkins, double-click: $startScriptPath" "Yellow"
    Write-ColorOutput "   Atau jalankan: java -jar C:\jenkins\jenkins.war --httpPort=8080" "Yellow"
    
    return $true
}

# Fungsi untuk setup monitoring
function Setup-Monitoring {
    if ($SkipMonitoring) {
        Write-ColorOutput "⏭️  Skipping Monitoring setup..." "Yellow"
        return $true
    }

    Write-ColorOutput "📊 Setting up Monitoring..." "Cyan"
    
    # Copy monitoring files
    if (Test-Path "monitoring") {
        Write-ColorOutput "📁 Monitoring files sudah ada!" "Green"
    }
    else {
        Write-ColorOutput "❌ Folder monitoring tidak ditemukan" "Red"
        return $false
    }
    
    return $true
}

# Fungsi untuk test aplikasi
function Test-Application {
    Write-ColorOutput "🧪 Testing aplikasi..." "Cyan"
    
    # Test Docker Compose
    if (Test-Path "docker-compose.yml") {
        Write-ColorOutput "📦 Testing Docker Compose..." "Yellow"
        try {
            docker-compose up -d
            Start-Sleep -Seconds 10
            
            # Test backend
            $backendResponse = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing -ErrorAction SilentlyContinue
            if ($backendResponse.StatusCode -eq 200) {
                Write-ColorOutput "✅ Backend berjalan dengan baik!" "Green"
            }
            else {
                Write-ColorOutput "⚠️  Backend mungkin belum siap" "Yellow"
            }
            
            # Test frontend
            $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -ErrorAction SilentlyContinue
            if ($frontendResponse.StatusCode -eq 200) {
                Write-ColorOutput "✅ Frontend berjalan dengan baik!" "Green"
            }
            else {
                Write-ColorOutput "⚠️  Frontend mungkin belum siap" "Yellow"
            }
            
            docker-compose down
        }
        catch {
            Write-ColorOutput "❌ Error testing aplikasi: $($_.Exception.Message)" "Red"
        }
    }
    else {
        Write-ColorOutput "❌ docker-compose.yml tidak ditemukan" "Red"
    }
}

# Fungsi untuk menampilkan next steps
function Show-NextSteps {
    Write-ColorOutput "🎉 SETUP SELESAI!" "Green"
    Write-Host ""
    Write-ColorOutput "LANGKAH SELANJUTNYA:" "Yellow"
    Write-Host ""
    Write-Host "1. 🐳 DOCKER COMPOSE (Paling Mudah):"
    Write-Host "   docker-compose up -d"
    Write-Host "   Buka: http://localhost:3000"
    Write-Host ""
    Write-Host "2. ☸️  KUBERNETES:"
    Write-Host "   cd kubernetes"
    Write-Host "   .\deploy.sh"
    Write-Host ""
    Write-Host "3. 🔧 JENKINS:"
    Write-Host "   Double-click: C:\jenkins\start-jenkins.bat"
    Write-Host "   Buka: http://localhost:8080"
    Write-Host ""
    Write-Host "4. 📊 MONITORING:"
    Write-Host "   cd monitoring"
    Write-Host "   docker-compose up -d"
    Write-Host "   Buka: http://localhost:3001 (Grafana)"
    Write-Host ""
    Write-ColorOutput "📚 BACA PANDUAN LENGKAP:" "Yellow"
    Write-Host "   docs\PANDUAN_LENGKAP_UNTUK_AWAM.md"
    Write-Host ""
    Write-ColorOutput "🆘 BUTUH BANTUAN?" "Yellow"
    Write-Host "   - Cek troubleshooting di panduan"
    Write-Host "   - Google error message"
    Write-Host "   - Tanya di forum Stack Overflow"
    Write-Host ""
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Show-Header

Write-ColorOutput "🚀 MULAI SETUP VOTING APP DEVOPS PROJECT" "Green"
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-ColorOutput "⚠️  Script ini sebaiknya dijalankan sebagai Administrator" "Yellow"
    Write-ColorOutput "   Beberapa instalasi mungkin memerlukan hak admin" "Yellow"
    $continue = Read-Host "Lanjutkan? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

$success = $true

# Setup components
if (-not (Setup-Docker)) { $success = $false }
if (-not (Setup-Kubernetes)) { $success = $false }
if (-not (Setup-Git)) { $success = $false }
if (-not (Setup-Jenkins)) { $success = $false }
if (-not (Setup-Monitoring)) { $success = $false }

# Test application
if ($success) {
    Test-Application
}

# Show results
Write-Host ""
if ($success) {
    Show-NextSteps
}
else {
    Write-ColorOutput "❌ Setup tidak lengkap. Cek error di atas." "Red"
    Write-ColorOutput "   Coba jalankan script lagi atau cek panduan troubleshooting." "Yellow"
}

Write-Host ""
Write-ColorOutput "Tekan Enter untuk keluar..." "Gray"
Read-Host 