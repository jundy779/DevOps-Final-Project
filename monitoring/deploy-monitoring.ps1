# Script PowerShell untuk deploy monitoring stack

Write-Host "Memulai deployment monitoring stack..." -ForegroundColor Green

# Cek apakah Docker berjalan
try {
    docker version | Out-Null
    Write-Host "Docker terdeteksi dan berjalan" -ForegroundColor Green
} catch {
    Write-Host "Error: Docker tidak berjalan atau tidak terinstall" -ForegroundColor Red
    Write-Host "Silakan jalankan Docker Desktop terlebih dahulu" -ForegroundColor Yellow
    exit 1
}

# Buat direktori yang diperlukan
Write-Host "Membuat direktori yang diperlukan..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "grafana/provisioning/datasources" | Out-Null
New-Item -ItemType Directory -Force -Path "grafana/provisioning/dashboards" | Out-Null
New-Item -ItemType Directory -Force -Path "grafana/dashboards" | Out-Null

# Deploy monitoring stack
Write-Host "Deploying monitoring stack..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nMonitoring stack berhasil di-deploy!" -ForegroundColor Green
    Write-Host "Akses Prometheus di: http://localhost:9090" -ForegroundColor Cyan
    Write-Host "Akses Grafana di: http://localhost:3001" -ForegroundColor Cyan
    Write-Host "Kredensial Grafana:" -ForegroundColor Yellow
    Write-Host "Username: admin" -ForegroundColor White
    Write-Host "Password: admin" -ForegroundColor White
} else {
    Write-Host "Error: Gagal deploy monitoring stack" -ForegroundColor Red
} 