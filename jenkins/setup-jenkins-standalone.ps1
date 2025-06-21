<<<<<<< HEAD
# Jenkins Standalone Setup Script for Windows
Write-Host "🚀 Setting up Jenkins Standalone..." -ForegroundColor Green

# Check if Java is installed
Write-Host "📋 Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "✅ Java is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Java is not installed. Please install Java 8 or higher." -ForegroundColor Red
    Write-Host "Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Create Jenkins directory
$jenkinsDir = "C:\jenkins"
if (!(Test-Path $jenkinsDir)) {
    Write-Host "📁 Creating Jenkins directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $jenkinsDir -Force
}

# Download Jenkins WAR file
$jenkinsUrl = "https://get.jenkins.io/war-stable/latest/jenkins.war"
$jenkinsWar = "$jenkinsDir\jenkins.war"

if (!(Test-Path $jenkinsWar)) {
    Write-Host "📥 Downloading Jenkins..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsWar
}

# Create Jenkins service script
$serviceScript = @"
@echo off
cd /d C:\jenkins
java -jar jenkins.war --httpPort=8080
"@

$serviceScriptPath = "$jenkinsDir\start-jenkins.bat"
$serviceScript | Out-File -FilePath $serviceScriptPath -Encoding ASCII

Write-Host "✅ Jenkins setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 To start Jenkins:" -ForegroundColor Yellow
Write-Host "1. Run: $serviceScriptPath" -ForegroundColor Cyan
Write-Host "2. Open browser: http://localhost:8080" -ForegroundColor Cyan
Write-Host "3. Get admin password from: C:\jenkins\secrets\initialAdminPassword" -ForegroundColor Cyan
Write-Host ""
=======
# Jenkins Standalone Setup Script for Windows
Write-Host "🚀 Setting up Jenkins Standalone..." -ForegroundColor Green

# Check if Java is installed
Write-Host "📋 Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "✅ Java is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Java is not installed. Please install Java 8 or higher." -ForegroundColor Red
    Write-Host "Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Create Jenkins directory
$jenkinsDir = "C:\jenkins"
if (!(Test-Path $jenkinsDir)) {
    Write-Host "📁 Creating Jenkins directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $jenkinsDir -Force
}

# Download Jenkins WAR file
$jenkinsUrl = "https://get.jenkins.io/war-stable/latest/jenkins.war"
$jenkinsWar = "$jenkinsDir\jenkins.war"

if (!(Test-Path $jenkinsWar)) {
    Write-Host "📥 Downloading Jenkins..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $jenkinsUrl -OutFile $jenkinsWar
}

# Create Jenkins service script
$serviceScript = @"
@echo off
cd /d C:\jenkins
java -jar jenkins.war --httpPort=8080
"@

$serviceScriptPath = "$jenkinsDir\start-jenkins.bat"
$serviceScript | Out-File -FilePath $serviceScriptPath -Encoding ASCII

Write-Host "✅ Jenkins setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 To start Jenkins:" -ForegroundColor Yellow
Write-Host "1. Run: $serviceScriptPath" -ForegroundColor Cyan
Write-Host "2. Open browser: http://localhost:8080" -ForegroundColor Cyan
Write-Host "3. Get admin password from: C:\jenkins\secrets\initialAdminPassword" -ForegroundColor Cyan
Write-Host ""
>>>>>>> 5eec687 (Add Jenkinsfile for CI/CD)
Write-Host "🛑 To stop Jenkins: Press Ctrl+C in the terminal" -ForegroundColor Yellow 