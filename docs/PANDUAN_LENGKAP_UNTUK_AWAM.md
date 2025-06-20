# 🚀 PANDUAN LENGKAP UNTUK AWAM - Voting App DevOps Project

## 📋 Daftar Isi
1. [Apa itu Proyek Ini?](#apa-itu-proyek-ini)
2. [Persiapan Awal](#persiapan-awal)
3. [Cara Menjalankan Aplikasi](#cara-menjalankan-aplikasi)
4. [Setup Jenkins CI/CD](#setup-jenkins-cicd)
5. [Deploy ke Kubernetes](#deploy-ke-kubernetes)
6. [Monitoring dan Observabilitas](#monitoring-dan-observabilitas)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

---

## 🎯 Apa itu Proyek Ini?

### Penjelasan Sederhana
Ini adalah aplikasi voting sederhana yang terdiri dari:
- **Frontend**: Website untuk memilih kandidat
- **Backend**: Server yang mengolah data voting
- **Database**: Tempat menyimpan data voting

### Teknologi yang Digunakan
- **Docker**: Untuk "membungkus" aplikasi dalam container
- **Kubernetes**: Untuk menjalankan aplikasi di server produksi
- **Jenkins**: Untuk otomatisasi build dan deploy
- **Prometheus & Grafana**: Untuk monitoring aplikasi

---

## 🛠️ Persiapan Awal

### 1. Install Software yang Diperlukan

#### Windows
```powershell
# Install Chocolatey (package manager untuk Windows)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Docker Desktop
choco install docker-desktop

# Install kubectl
choco install kubernetes-cli

# Install minikube
choco install minikube

# Install Git
choco install git
```

#### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop
brew install --cask docker

# Install kubectl
brew install kubectl

# Install minikube
brew install minikube

# Install Git
brew install git
```

#### Linux (Ubuntu/Debian)
```bash
# Update package list
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Install Git
sudo apt install git
```

### 2. Verifikasi Instalasi
```bash
# Cek Docker
docker --version
docker-compose --version

# Cek kubectl
kubectl version --client

# Cek minikube
minikube version

# Cek Git
git --version
```

### 3. Clone Repository
```bash
# Clone proyek
git clone <URL_REPOSITORY_ANDA>
cd Final-DevOps

# Cek struktur folder
ls -la
```

---

## 🚀 Cara Menjalankan Aplikasi

### Opsi 1: Menggunakan Docker Compose (Paling Mudah)

#### Langkah 1: Jalankan Aplikasi
```bash
# Masuk ke folder proyek
cd Final-DevOps

# Jalankan semua komponen
docker-compose up -d

# Cek status container
docker-compose ps
```

#### Langkah 2: Akses Aplikasi
- **Frontend**: Buka browser, ketik `http://localhost:3000`
- **Backend API**: Buka browser, ketik `http://localhost:8000`
- **Database**: Bisa diakses di `localhost:5432`

#### Langkah 3: Test Aplikasi
```bash
# Test kesehatan backend
curl http://localhost:8000/health

# Lihat data voting
curl http://localhost:8000/api/votes

# Tambah voting (ganti 1 dengan ID kandidat)
curl -X POST http://localhost:8000/api/votes \
  -H "Content-Type: application/json" \
  -d '{"candidate_id": 1}'
```

#### Langkah 4: Stop Aplikasi
```bash
# Stop semua container
docker-compose down

# Hapus semua data (opsional)
docker-compose down -v
```

### Opsi 2: Menjalankan Secara Manual

#### Backend
```bash
cd backend
npm install
npm start
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

#### Database
```bash
# Install PostgreSQL atau gunakan Docker
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=voting_db \
  -p 5432:5432 \
  postgres:15-alpine
```

---

## 🔄 Setup Jenkins CI/CD

### 1. Install Jenkins

#### Windows (PowerShell)
```powershell
# Download Jenkins
Invoke-WebRequest -Uri "https://get.jenkins.io/war-stable/latest/jenkins.war" -OutFile "jenkins.war"

# Jalankan Jenkins
java -jar jenkins.war --httpPort=8080
```

#### Linux/macOS
```bash
# Install Java
sudo apt install openjdk-11-jdk  # Ubuntu/Debian
brew install openjdk@11          # macOS

# Download dan jalankan Jenkins
wget https://get.jenkins.io/war-stable/latest/jenkins.war
java -jar jenkins.war --httpPort=8080
```

### 2. Setup Jenkins Pertama Kali

1. **Buka Browser**: Ketik `http://localhost:8080`
2. **Cari Password**: Lihat di terminal atau file:
   ```bash
   # Windows
   type C:\Users\[USERNAME]\.jenkins\secrets\initialAdminPassword
   
   # Linux/macOS
   cat ~/.jenkins/secrets/initialAdminPassword
   ```
3. **Install Plugin**: Pilih "Install suggested plugins"
4. **Buat Admin User**: Isi username dan password
5. **Konfigurasi URL**: Biarkan default

### 3. Install Plugin yang Diperlukan

1. Buka Jenkins Dashboard
2. Klik "Manage Jenkins" → "Manage Plugins"
3. Klik tab "Available"
4. Cari dan install plugin berikut:
   - Docker Pipeline
   - Kubernetes
   - Git
   - Pipeline
   - Blue Ocean

### 4. Setup Credentials

#### Docker Hub Credentials
1. Klik "Manage Jenkins" → "Manage Credentials"
2. Klik "System" → "Global credentials"
3. Klik "Add Credentials"
4. Pilih "Username with password"
5. Isi:
   - ID: `docker-hub`
   - Username: Username Docker Hub Anda
   - Password: Password atau Access Token Docker Hub

#### Kubernetes Credentials
1. Buat kubeconfig file:
   ```bash
   # Jika menggunakan minikube
   minikube kubectl config view --minify --flatten > kubeconfig
   
   # Jika menggunakan kind
   kind export kubeconfig --name voting-cluster > kubeconfig
   ```

2. Upload ke Jenkins:
   - Klik "Add Credentials"
   - Pilih "Secret file"
   - ID: `kubeconfig`
   - Upload file kubeconfig

### 5. Buat Pipeline Job

1. Klik "New Item"
2. Pilih "Pipeline"
3. Nama: `voting-app-pipeline`
4. Klik "OK"
5. Scroll ke "Pipeline" section
6. Pilih "Pipeline script from SCM"
7. SCM: Git
8. Repository URL: URL repository Anda
9. Credentials: Pilih credentials Git (jika ada)
10. Branch: `*/main` atau `*/master`
11. Script Path: `jenkins/Jenkinsfile`
12. Klik "Save"

### 6. Jalankan Pipeline

1. Klik job `voting-app-pipeline`
2. Klik "Build Now"
3. Klik nomor build untuk melihat progress
4. Klik "Console Output" untuk melihat log detail

---

## ☸️ Deploy ke Kubernetes

### 1. Setup Kubernetes Cluster

#### Menggunakan Minikube (Paling Mudah)
```bash
# Start minikube
minikube start --driver=docker

# Cek status
minikube status

# Enable addons yang diperlukan
minikube addons enable ingress
minikube addons enable metrics-server
```

#### Menggunakan Kind
```bash
# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Buat cluster
kind create cluster --name voting-cluster

# Cek cluster
kind get clusters
```

### 2. Deploy Aplikasi

#### Cara Otomatis (Menggunakan Script)
```bash
# Masuk ke folder kubernetes
cd kubernetes

# Buat script executable
chmod +x deploy.sh

# Jalankan deploy
./deploy.sh
```

#### Cara Manual (Step by Step)
```bash
# 1. Buat namespace
kubectl apply -f namespace.yaml

# 2. Buat secret untuk database
kubectl apply -f secret.yaml

# 3. Deploy PostgreSQL
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
kubectl apply -f postgres-pvc.yaml

# 4. Deploy Backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# 5. Deploy Frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

# 6. Deploy Ingress (jika ada)
kubectl apply -f ingress.yaml
```

### 3. Cek Status Deployment
```bash
# Cek semua resource
kubectl get all -n voting-app

# Cek pods
kubectl get pods -n voting-app

# Cek services
kubectl get services -n voting-app

# Cek logs
kubectl logs deployment/backend -n voting-app
kubectl logs deployment/frontend -n voting-app
```

### 4. Akses Aplikasi

#### Menggunakan Port Forward
```bash
# Port forward frontend
kubectl port-forward service/frontend-service 3000:80 -n voting-app

# Port forward backend
kubectl port-forward service/backend-service 8000:8000 -n voting-app
```

#### Menggunakan Minikube
```bash
# Buka tunnel untuk LoadBalancer
minikube tunnel

# Cek IP service
kubectl get service frontend-service -n voting-app
```

### 5. Undeploy Aplikasi
```bash
# Menggunakan script
cd kubernetes
./undeploy.sh

# Atau manual
kubectl delete namespace voting-app
```

---

## 📊 Monitoring dan Observabilitas

### 1. Setup Prometheus dan Grafana

#### Menggunakan Docker Compose
```bash
cd monitoring
docker-compose up -d
```

#### Menggunakan Kubernetes
```bash
# Deploy Prometheus
kubectl apply -f monitoring/kubernetes-files/prometheus-config.yaml

# Deploy Grafana
kubectl apply -f monitoring/kubernetes-files/grafana-deployment.yaml
kubectl apply -f monitoring/kubernetes-files/grafana-service.yaml
```

### 2. Akses Monitoring

- **Grafana**: `http://localhost:3001`
  - Username: `admin`
  - Password: `admin`
- **Prometheus**: `http://localhost:9090`

### 3. Import Dashboard

1. Buka Grafana
2. Klik "+" → "Import"
3. Upload file `monitoring/grafana/dashboards/voting-app.json`
4. Klik "Import"

### 4. Metrics yang Tersedia

- **Application Metrics**:
  - Total votes per candidate
  - API response time
  - Error rates
- **Infrastructure Metrics**:
  - CPU usage
  - Memory usage
  - Network traffic

---

## 🔧 Troubleshooting

### Masalah Umum dan Solusinya

#### 1. Docker Container Tidak Start
```bash
# Cek logs container
docker-compose logs

# Cek logs container tertentu
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres

# Restart container
docker-compose restart
```

#### 2. Kubernetes Pod Tidak Ready
```bash
# Cek detail pod
kubectl describe pod <pod-name> -n voting-app

# Cek logs pod
kubectl logs <pod-name> -n voting-app

# Cek events
kubectl get events -n voting-app --sort-by='.lastTimestamp'
```

#### 3. Database Connection Error
```bash
# Test koneksi database
kubectl run test-db --image=postgres:15-alpine -n voting-app \
  --rm -i --restart=Never -- \
  psql -h postgres-service -U voting_user -d voting_db

# Cek secret
kubectl get secret voting-app-secret -n voting-app -o yaml
```

#### 4. Jenkins Pipeline Error

**Error: Permission denied pada node_modules**
```bash
# Solusi 1: Clean workspace di Jenkins
# Buka job → Build → Workspace → Wipe Out

# Solusi 2: Tambahkan cleanBeforeCheckout() di Jenkinsfile
stage('Checkout') {
    steps {
        cleanBeforeCheckout()
        checkout scm
    }
}
```

**Error: Cannot connect to Docker daemon**
```bash
# Pastikan Docker Desktop running
# Atau jalankan Docker daemon
sudo systemctl start docker
```

#### 5. Minikube Issues
```bash
# Reset minikube
minikube delete
minikube start

# Cek status
minikube status

# Buka dashboard
minikube dashboard
```

### Debug Commands yang Berguna

```bash
# Cek resource usage
kubectl top pods -n voting-app
kubectl top nodes

# Cek network connectivity
kubectl run test-curl --image=curlimages/curl -n voting-app \
  --rm -i --restart=Never -- \
  curl http://backend-service:8000/health

# Cek service endpoints
kubectl get endpoints -n voting-app

# Cek configmaps dan secrets
kubectl get configmaps -n voting-app
kubectl get secrets -n voting-app
```

---

## ❓ FAQ (Frequently Asked Questions)

### Q: Apa bedanya Docker Compose dan Kubernetes?
**A**: 
- **Docker Compose**: Untuk development lokal, mudah digunakan
- **Kubernetes**: Untuk production, lebih kompleks tapi lebih powerful

### Q: Kenapa perlu Jenkins?
**A**: Jenkins mengotomatisasi proses build, test, dan deploy sehingga tidak perlu manual setiap kali ada perubahan kode.

### Q: Bagaimana cara backup database?
**A**: 
```bash
# Backup PostgreSQL
kubectl exec -it <postgres-pod> -n voting-app -- \
  pg_dump -U voting_user voting_db > backup.sql

# Restore
kubectl exec -i <postgres-pod> -n voting-app -- \
  psql -U voting_user voting_db < backup.sql
```

### Q: Bagaimana cara scale aplikasi?
**A**: 
```bash
# Scale backend
kubectl scale deployment backend --replicas=3 -n voting-app

# Scale frontend
kubectl scale deployment frontend --replicas=2 -n voting-app
```

### Q: Bagaimana cara update aplikasi?
**A**: 
1. Update kode
2. Build image baru
3. Update deployment dengan image baru
4. Kubernetes akan rolling update secara otomatis

### Q: Bagaimana cara monitoring aplikasi?
**A**: 
1. Setup Prometheus dan Grafana
2. Import dashboard
3. Monitor metrics seperti response time, error rate, resource usage

---

## 📚 Referensi dan Link Berguna

### Dokumentasi Resmi
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Prometheus Documentation](https://prometheus.io/docs/)

### Tutorial Video
- [Docker Tutorial for Beginners](https://www.youtube.com/watch?v=3c-iBn73dDE)
- [Kubernetes Tutorial for Beginners](https://www.youtube.com/watch?v=s_o8dwzRlu4)
- [Jenkins Tutorial](https://www.youtube.com/watch?v=89yWXXIOisk)

### Tools Online
- [Docker Hub](https://hub.docker.com/)
- [Kubernetes Playground](https://www.katacoda.com/courses/kubernetes)
- [Jenkins Blue Ocean](https://www.jenkins.io/projects/blueocean/)

---

## 🆘 Butuh Bantuan?

Jika mengalami masalah:

1. **Cek dokumentasi** di folder `docs/`
2. **Lihat troubleshooting** section di atas
3. **Cek logs** aplikasi dan container
4. **Google error message** yang muncul
5. **Tanya di forum** seperti Stack Overflow

### Contact Information
- **Email**: [your-email@example.com]
- **GitHub Issues**: [repository-issues-url]
- **Slack/Discord**: [community-channel]

---

**Selamat mencoba! 🎉**

Jika panduan ini membantu, jangan lupa untuk memberikan ⭐ di repository ini! 