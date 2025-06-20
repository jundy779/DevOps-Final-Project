# Panduan Instalasi Aplikasi Voting Online

Selamat datang di panduan instalasi aplikasi Voting Online! Panduan ini akan membantu Anda menginstal dan menjalankan aplikasi dengan mudah.

## Apa yang Anda Butuhkan

Sebelum memulai, pastikan komputer Anda memiliki:
1. Node.js (versi 20 atau lebih baru)
2. Docker Desktop
3. Git
4. Koneksi internet yang stabil

## Cara Instalasi

### Langkah 1: Download Aplikasi
1. Buka Command Prompt (CMD) atau Terminal
2. Ketik perintah berikut:
```bash
git clone https://github.com/username/voting-app.git
cd voting-app
```

### Langkah 2: Persiapan Aplikasi
1. Buka folder `backend`
2. Buat file baru bernama `.env`
3. Isi file tersebut dengan:
```
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=voting_db
DB_USER=postgres
DB_PASSWORD=password123
JWT_SECRET=rahasia123
```

### Langkah 3: Instalasi Program
1. Buka Command Prompt (CMD) atau Terminal
2. Masuk ke folder backend:
```bash
cd backend
npm install
```
3. Masuk ke folder frontend:
```bash
cd frontend
npm install
```

### Langkah 4: Menjalankan Aplikasi
Cara termudah adalah menggunakan Docker:

1. Buka Command Prompt (CMD) atau Terminal
2. Ketik perintah:
```bash
docker-compose up --build
```
3. Tunggu sampai semua proses selesai
4. Buka browser dan ketik: http://localhost:3000

## Cara Menggunakan Aplikasi

1. Buka browser dan ketik: http://localhost:3000
2. Login dengan:
   - Username: admin
   - Password: admin123

## Jika Ada Masalah

### Masalah 1: Port Sudah Digunakan
Jika muncul pesan error tentang port yang sudah digunakan:
1. Tutup aplikasi yang mungkin menggunakan port tersebut
2. Restart komputer
3. Coba jalankan aplikasi lagi

### Masalah 2: Database Error
Jika muncul pesan error tentang database:
1. Pastikan Docker Desktop sudah berjalan
2. Restart Docker Desktop
3. Jalankan aplikasi lagi

### Masalah 3: Node.js Error
Jika muncul pesan error tentang Node.js:
1. Download dan install Node.js versi 20 dari website resmi
2. Restart komputer
3. Jalankan aplikasi lagi

## Cara Menutup Aplikasi

1. Tekan Ctrl + C di Command Prompt atau Terminal
2. Tunggu sampai semua proses berhenti
3. Tutup Command Prompt atau Terminal

## Tips Penting

1. **Jangan lupa ganti password default**
   - Setelah berhasil login, segera ganti password admin
   - Gunakan password yang kuat dan aman

2. **Backup data secara berkala**
   - Simpan data penting secara teratur
   - Buat cadangan database setiap minggu

3. **Jaga keamanan**
   - Jangan bagikan kredensial login
   - Gunakan HTTPS di production
   - Update aplikasi secara berkala

## Butuh Bantuan?

Jika Anda mengalami kesulitan, silakan:
1. Periksa bagian "Jika Ada Masalah" di atas
2. Hubungi tim support di:
   - Email: support@voting-app.com
   - WhatsApp: +62 123 4567 890

## Catatan Penting

- Pastikan komputer Anda memiliki ruang penyimpanan minimal 2GB
- Disarankan menggunakan browser Chrome atau Firefox terbaru
- Jangan tutup Command Prompt atau Terminal saat aplikasi berjalan
- Selalu backup data sebelum melakukan update

## Panduan Video

Untuk panduan visual, Anda dapat menonton video tutorial di:
- YouTube: [Link Video Tutorial]
- Website: [Link Website Tutorial]

## Update Aplikasi

Untuk mengupdate aplikasi ke versi terbaru:
1. Buka Command Prompt atau Terminal
2. Ketik perintah:
```bash
git pull
docker-compose up --build
```

## Keamanan Data

1. **Password**
   - Gunakan kombinasi huruf besar, kecil, angka, dan simbol
   - Minimal 8 karakter
   - Ganti password secara berkala

2. **Backup**
   - Lakukan backup setiap minggu
   - Simpan backup di tempat yang aman
   - Test restore backup secara berkala

3. **Akses**
   - Batasi akses ke server
   - Gunakan firewall
   - Monitor aktivitas mencurigakan

## Kontak Darurat

Jika terjadi masalah serius:
1. Hubungi tim support 24/7:
   - Telepon: +62 123 4567 890
   - Email: emergency@voting-app.com
2. Sertakan:
   - Screenshot error
   - Log error
   - Langkah-langkah yang sudah dilakukan 

## Panduan Deployment ke Server

### Persiapan Server
1. **Pilih Provider Server**
   - DigitalOcean (Direkomendasikan untuk pemula)
   - AWS
   - Google Cloud
   - VPS lokal

2. **Spesifikasi Server Minimal**
   - RAM: 2GB
   - CPU: 2 Core
   - Storage: 20GB
   - Sistem Operasi: Ubuntu 20.04 LTS

### Langkah Deployment

#### A. Menggunakan DigitalOcean (Cara Termudah)

1. **Buat Akun DigitalOcean**
   - Kunjungi [digitalocean.com](https://digitalocean.com)
   - Klik "Sign Up"
   - Isi data yang diminta
   - Verifikasi email

2. **Buat Droplet (Server)**
   - Klik "Create" → "Droplets"
   - Pilih Ubuntu 20.04
   - Pilih paket Basic
   - Pilih datacenter terdekat (Singapore)
   - Klik "Create Droplet"

3. **Akses Server**
   - Buka Command Prompt di komputer Anda
   - Ketik perintah:
   ```bash
   ssh root@IP_SERVER_ANDA
   ```
   - Masukkan password yang dikirim ke email

4. **Instalasi Docker**
   ```bash
   apt update
   apt install docker.io docker-compose
   ```

5. **Upload Aplikasi**
   - Buka FileZilla atau WinSCP
   - Hubungkan ke server menggunakan:
     - Host: IP_SERVER_ANDA
     - Username: root
     - Password: password_server
   - Upload folder aplikasi ke server

6. **Jalankan Aplikasi**
   ```bash
   cd voting-app
   docker-compose up -d
   ```

7. **Setup Domain**
   - Beli domain di [namecheap.com](https://namecheap.com)
   - Arahkan domain ke IP server
   - Tunggu 24-48 jam untuk propagasi DNS

#### B. Menggunakan VPS Lokal

1. **Persiapan Server**
   - Install Ubuntu Server 20.04
   - Update sistem:
   ```bash
   sudo apt update
   sudo apt upgrade
   ```

2. **Install Dependencies**
   ```bash
   sudo apt install docker.io docker-compose nginx
   ```

3. **Setup Nginx**
   - Buat file konfigurasi:
   ```bash
   sudo nano /etc/nginx/sites-available/voting-app
   ```
   - Isi dengan:
   ```nginx
   server {
       listen 80;
       server_name domain-anda.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```
   - Aktifkan konfigurasi:
   ```bash
   sudo ln -s /etc/nginx/sites-available/voting-app /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

4. **Setup SSL (HTTPS)**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d domain-anda.com
   ```

### Verifikasi Deployment

1. **Cek Aplikasi**
   - Buka domain Anda di browser
   - Pastikan bisa login
   - Test fitur-fitur utama

2. **Cek Keamanan**
   - Pastikan menggunakan HTTPS
   - Test login dengan password yang salah
   - Cek firewall settings

3. **Cek Performa**
   - Monitor penggunaan CPU dan RAM
   - Test kecepatan loading
   - Cek response time

### Maintenance

1. **Backup Rutin**
   ```bash
   # Backup database
   docker-compose exec db pg_dump -U postgres voting_db > backup.sql
   
   # Backup file
   tar -czf voting-app-backup.tar.gz voting-app/
   ```

2. **Update Aplikasi**
   ```bash
   cd voting-app
   git pull
   docker-compose down
   docker-compose up -d --build
   ```

3. **Monitor Server**
   - Install monitoring tools:
   ```bash
   docker-compose -f docker-compose.monitoring.yml up -d
   ```
   - Akses dashboard di: http://domain-anda.com:3000

### Troubleshooting Deployment

1. **Aplikasi Tidak Bisa Diakses**
   - Cek status Docker:
   ```bash
   docker-compose ps
   ```
   - Cek logs:
   ```bash
   docker-compose logs
   ```
   - Restart aplikasi:
   ```bash
   docker-compose restart
   ```

2. **Database Error**
   - Cek koneksi database:
   ```bash
   docker-compose exec db psql -U postgres
   ```
   - Restore dari backup jika perlu

3. **Server Lambat**
   - Cek penggunaan resources:
   ```bash
   htop
   ```
   - Optimasi konfigurasi Nginx
   - Upgrade server jika perlu

### Keamanan Server

1. **Firewall**
   ```bash
   sudo ufw allow 80
   sudo ufw allow 443
   sudo ufw enable
   ```

2. **Update Rutin**
   ```bash
   sudo apt update
   sudo apt upgrade
   ```

3. **Monitor Logs**
   ```bash
   sudo tail -f /var/log/nginx/access.log
   sudo tail -f /var/log/nginx/error.log
   ```

### Kontak Support Deployment

Jika mengalami masalah saat deployment:
- Email: deployment@voting-app.com
- WhatsApp: +62 123 4567 890
- Jam kerja: 24/7 

## Panduan CI/CD dengan Jenkins

### Persiapan Jenkins

1. **Install Jenkins**
   ```bash
   # Install Java
   sudo apt update
   sudo apt install openjdk-11-jdk

   # Install Jenkins
   wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
   sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
   sudo apt update
   sudo apt install jenkins
   ```

2. **Start Jenkins**
   ```bash
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ```

3. **Akses Jenkins**
   - Buka browser: http://localhost:8080
   - Dapatkan password awal:
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

### Setup Pipeline

#### 1. Pipeline Backend

1. **Buat Pipeline Baru**
   - Klik "New Item"
   - Nama: "voting-app-backend"
   - Pilih "Pipeline"
   - Klik OK

2. **Konfigurasi Pipeline**
   ```groovy
   pipeline {
       agent any
       
       environment {
           DOCKER_IMAGE = 'voting-app-backend'
           DOCKER_TAG = "${BUILD_NUMBER}"
       }
       
       stages {
           stage('Checkout') {
               steps {
                   checkout scm
               }
           }
           
           stage('Install Dependencies') {
               steps {
                   dir('backend') {
                       sh 'npm install'
                   }
               }
           }
           
           stage('Run Tests') {
               steps {
                   dir('backend') {
                       sh 'npm test'
                   }
               }
           }
           
           stage('Build Docker Image') {
               steps {
                   dir('backend') {
                       sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                   }
               }
           }
           
           stage('Push to Registry') {
               steps {
                   withCredentials([usernamePassword(credentialsId: 'docker-hub', 
                       usernameVariable: 'DOCKER_USER', 
                       passwordVariable: 'DOCKER_PASS')]) {
                       sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                       sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                   }
               }
           }
           
           stage('Deploy to Staging') {
               when {
                   branch 'develop'
               }
               steps {
                   sh "kubectl set image deployment/backend backend=${DOCKER_IMAGE}:${DOCKER_TAG} -n staging"
               }
           }
           
           stage('Deploy to Production') {
               when {
                   branch 'main'
               }
               steps {
                   sh "kubectl set image deployment/backend backend=${DOCKER_IMAGE}:${DOCKER_TAG} -n production"
               }
           }
       }
       
       post {
           always {
               cleanWs()
           }
           success {
               emailext (
                   subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}",
                   body: "Check console output at ${env.BUILD_URL}",
                   to: 'team@voting-app.com'
               )
           }
           failure {
               emailext (
                   subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                   body: "Check console output at ${env.BUILD_URL}",
                   to: 'team@voting-app.com'
               )
           }
       }
   }
   ```

#### 2. Pipeline Frontend

1. **Buat Pipeline Baru**
   - Klik "New Item"
   - Nama: "voting-app-frontend"
   - Pilih "Pipeline"
   - Klik OK

2. **Konfigurasi Pipeline**
   ```groovy
   pipeline {
       agent any
       
       environment {
           DOCKER_IMAGE = 'voting-app-frontend'
           DOCKER_TAG = "${BUILD_NUMBER}"
       }
       
       stages {
           stage('Checkout') {
               steps {
                   checkout scm
               }
           }
           
           stage('Install Dependencies') {
               steps {
                   dir('frontend') {
                       sh 'npm install'
                   }
               }
           }
           
           stage('Lint') {
               steps {
                   dir('frontend') {
                       sh 'npm run lint'
                   }
               }
           }
           
           stage('Run Tests') {
               steps {
                   dir('frontend') {
                       sh 'npm test'
                   }
               }
           }
           
           stage('Build') {
               steps {
                   dir('frontend') {
                       sh 'npm run build'
                   }
               }
           }
           
           stage('Build Docker Image') {
               steps {
                   dir('frontend') {
                       sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                   }
               }
           }
           
           stage('Push to Registry') {
               steps {
                   withCredentials([usernamePassword(credentialsId: 'docker-hub', 
                       usernameVariable: 'DOCKER_USER', 
                       passwordVariable: 'DOCKER_PASS')]) {
                       sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                       sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                   }
               }
           }
           
           stage('Deploy to Staging') {
               when {
                   branch 'develop'
               }
               steps {
                   sh "kubectl set image deployment/frontend frontend=${DOCKER_IMAGE}:${DOCKER_TAG} -n staging"
               }
           }
           
           stage('Deploy to Production') {
               when {
                   branch 'main'
               }
               steps {
                   sh "kubectl set image deployment/frontend frontend=${DOCKER_IMAGE}:${DOCKER_TAG} -n production"
               }
           }
       }
       
       post {
           always {
               cleanWs()
           }
           success {
               emailext (
                   subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}",
                   body: "Check console output at ${env.BUILD_URL}",
                   to: 'team@voting-app.com'
               )
           }
           failure {
               emailext (
                   subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                   body: "Check console output at ${env.BUILD_URL}",
                   to: 'team@voting-app.com'
               )
           }
       }
   }
   ```

### Multi-Job Pipeline

1. **Buat Multi-Job Pipeline**
   - Klik "New Item"
   - Nama: "voting-app-master"
   - Pilih "MultiJob"
   - Klik OK

2. **Konfigurasi Multi-Job**
   ```groovy
   pipeline {
       agent any
       
       stages {
           stage('Build and Test') {
               parallel {
                   stage('Backend') {
                       steps {
                           build job: 'voting-app-backend', 
                                 parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME)]
                       }
                   }
                   stage('Frontend') {
                       steps {
                           build job: 'voting-app-frontend', 
                                 parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME)]
                       }
                   }
               }
           }
           
           stage('Integration Tests') {
               steps {
                   dir('tests/integration') {
                       sh 'npm install'
                       sh 'npm test'
                   }
               }
           }
           
           stage('Deploy') {
               when {
                   branch 'main'
               }
               steps {
                   build job: 'voting-app-backend', 
                         parameters: [string(name: 'DEPLOY', value: 'true')]
                   build job: 'voting-app-frontend', 
                         parameters: [string(name: 'DEPLOY', value: 'true')]
               }
           }
       }
   }
   ```

### Konfigurasi Tambahan

1. **Setup Credentials**
   - Klik "Credentials" → "System" → "Global credentials"
   - Tambahkan credentials untuk:
     - Docker Hub
     - Kubernetes
     - GitHub

2. **Setup Webhook**
   - Di repository GitHub:
     - Settings → Webhooks
     - Add webhook
     - Payload URL: http://jenkins-url/github-webhook/
     - Content type: application/json

3. **Setup Notifications**
   - Install plugin "Email Extension"
   - Konfigurasi SMTP server
   - Setup template email

### Monitoring Pipeline

1. **Dashboard Jenkins**
   - Akses: http://jenkins-url
   - Lihat status pipeline
   - Cek build history
   - Monitor test results

2. **Logs dan Artifacts**
   - Cek console output
   - Download build artifacts
   - Analisis test reports

### Troubleshooting CI/CD

1. **Pipeline Gagal**
   - Cek console output
   - Verifikasi credentials
   - Pastikan dependencies terinstall

2. **Build Error**
   - Cek Docker build logs
   - Verifikasi Dockerfile
   - Pastikan registry accessible

3. **Deploy Error**
   - Cek Kubernetes logs
   - Verifikasi kubeconfig
   - Pastikan resources cukup

### Best Practices

1. **Keamanan**
   - Gunakan secrets untuk credentials
   - Batasi akses ke pipeline
   - Scan dependencies secara rutin

2. **Optimasi**
   - Cache dependencies
   - Gunakan parallel stages
   - Optimasi Docker layers

3. **Maintenance**
   - Backup Jenkins configuration
   - Update plugins secara rutin
   - Monitor disk usage

### Kontak Support CI/CD

Jika mengalami masalah dengan pipeline:
- Email: cicd@voting-app.com
- Slack: #jenkins-support
- Jam kerja: 24/7 

## Panduan Infrastructure dengan Kubernetes

### Setup Kubernetes Cluster

1. **Install Minikube (Development)**
   ```bash
   # Install Minikube
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   
   # Start Minikube
   minikube start --driver=docker
   ```

2. **Install kubectl**
   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

### Konfigurasi Namespace dan Ingress

1. **Buat Namespace**
   ```yaml
   # voting-namespace.yaml
   apiVersion: v1
   kind: Namespace
   metadata:
     name: voting
     labels:
       name: voting
       environment: production
   ```
   ```bash
   kubectl apply -f voting-namespace.yaml
   ```

2. **Setup Ingress Controller**
   ```bash
   # Install NGINX Ingress Controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
   ```

3. **Konfigurasi Ingress**
   ```yaml
   # voting-ingress.yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: voting-ingress
     namespace: voting
     annotations:
       nginx.ingress.kubernetes.io/rewrite-target: /
       nginx.ingress.kubernetes.io/ssl-redirect: "true"
   spec:
     rules:
     - host: voting-app.com
       http:
         paths:
         - path: /api
           pathType: Prefix
           backend:
             service:
               name: backend-service
               port:
                 number: 3000
         - path: /
           pathType: Prefix
           backend:
             service:
               name: frontend-service
               port:
                 number: 80
   ```
   ```bash
   kubectl apply -f voting-ingress.yaml
   ```

### Resource Management

1. **Resource Quotas**
   ```yaml
   # voting-quota.yaml
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: voting-quota
     namespace: voting
   spec:
     hard:
       requests.cpu: "4"
       requests.memory: 4Gi
       limits.cpu: "8"
       limits.memory: 8Gi
       pods: "10"
   ```
   ```bash
   kubectl apply -f voting-quota.yaml
   ```

2. **Network Policies**
   ```yaml
   # voting-network-policy.yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: voting-network-policy
     namespace: voting
   spec:
     podSelector:
       matchLabels:
         app: voting
     policyTypes:
     - Ingress
     - Egress
     ingress:
     - from:
       - namespaceSelector:
           matchLabels:
             name: voting
     egress:
     - to:
       - namespaceSelector:
           matchLabels:
             name: voting
   ```
   ```bash
   kubectl apply -f voting-network-policy.yaml
   ```

## Panduan Monitoring dengan Grafana

### Setup Prometheus

1. **Install Prometheus**
   ```bash
   # Add Prometheus Helm repo
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   
   # Install Prometheus
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --create-namespace
   ```

2. **Konfigurasi ServiceMonitor**
   ```yaml
   # voting-service-monitor.yaml
   apiVersion: monitoring.coreos.com/v1
   kind: ServiceMonitor
   metadata:
     name: voting-monitor
     namespace: monitoring
   spec:
     selector:
       matchLabels:
         app: voting
     endpoints:
     - port: metrics
       interval: 15s
   ```
   ```bash
   kubectl apply -f voting-service-monitor.yaml
   ```

### Setup Grafana

1. **Install Grafana**
   ```bash
   helm install grafana grafana/grafana \
     --namespace monitoring \
     --set persistence.enabled=true \
     --set service.type=LoadBalancer
   ```

2. **Konfigurasi Dashboard**
   ```json
   {
     "annotations": {
       "list": []
     },
     "editable": true,
     "fiscalYearStartMonth": 0,
     "graphTooltip": 0,
     "links": [],
     "liveNow": false,
     "panels": [
       {
         "datasource": {
           "type": "prometheus",
           "uid": "prometheus"
         },
         "fieldConfig": {
           "defaults": {
             "color": {
               "mode": "palette-classic"
             },
             "custom": {
               "axisCenteredZero": false,
               "axisColorMode": "text",
               "axisLabel": "",
               "axisPlacement": "auto",
               "barAlignment": 0,
               "drawStyle": "line",
               "fillOpacity": 0,
               "gradientMode": "none",
               "hideFrom": {
                 "legend": false,
                 "tooltip": false,
                 "viz": false
               },
               "lineInterpolation": "linear",
               "lineWidth": 1,
               "pointSize": 5,
               "scaleDistribution": {
                 "type": "linear"
               },
               "showPoints": "auto",
               "spanNulls": false,
               "stacking": {
                 "group": "A",
                 "mode": "none"
               },
               "thresholdsStyle": {
                 "mode": "off"
               }
             },
             "mappings": [],
             "thresholds": {
               "mode": "absolute",
               "steps": [
                 {
                   "color": "green",
                   "value": null
                 },
                 {
                   "color": "red",
                   "value": 80
                 }
               ]
             }
           },
           "overrides": []
         },
         "gridPos": {
           "h": 8,
           "w": 12,
           "x": 0,
           "y": 0
         },
         "id": 1,
         "options": {
           "legend": {
             "calcs": [],
             "displayMode": "list",
             "placement": "bottom",
             "showLegend": true
           },
           "tooltip": {
             "mode": "single",
             "sort": "none"
           }
         },
         "title": "Request Rate",
         "type": "timeseries"
       },
       {
         "datasource": {
           "type": "prometheus",
           "uid": "prometheus"
         },
         "fieldConfig": {
           "defaults": {
             "color": {
               "mode": "palette-classic"
             },
             "custom": {
               "axisCenteredZero": false,
               "axisColorMode": "text",
               "axisLabel": "",
               "axisPlacement": "auto",
               "barAlignment": 0,
               "drawStyle": "line",
               "fillOpacity": 0,
               "gradientMode": "none",
               "hideFrom": {
                 "legend": false,
                 "tooltip": false,
                 "viz": false
               },
               "lineInterpolation": "linear",
               "lineWidth": 1,
               "pointSize": 5,
               "scaleDistribution": {
                 "type": "linear"
               },
               "showPoints": "auto",
               "spanNulls": false,
               "stacking": {
                 "group": "A",
                 "mode": "none"
               },
               "thresholdsStyle": {
                 "mode": "off"
               }
             },
             "mappings": [],
             "thresholds": {
               "mode": "absolute",
               "steps": [
                 {
                   "color": "green",
                   "value": null
                 },
                 {
                   "color": "red",
                   "value": 80
                 }
               ]
             }
           },
           "overrides": []
         },
         "gridPos": {
           "h": 8,
           "w": 12,
           "x": 12,
           "y": 0
         },
         "id": 2,
         "options": {
           "legend": {
             "calcs": [],
             "displayMode": "list",
             "placement": "bottom",
             "showLegend": true
           },
           "tooltip": {
             "mode": "single",
             "sort": "none"
           }
         },
         "title": "Backend Latency",
         "type": "timeseries"
       },
       {
         "datasource": {
           "type": "prometheus",
           "uid": "prometheus"
         },
         "fieldConfig": {
           "defaults": {
             "color": {
               "mode": "thresholds"
             },
             "mappings": [],
             "thresholds": {
               "mode": "absolute",
               "steps": [
                 {
                   "color": "green",
                   "value": null
                 },
                 {
                   "color": "red",
                   "value": 80
                 }
               ]
             }
           },
           "overrides": []
         },
         "gridPos": {
           "h": 8,
           "w": 12,
           "x": 0,
           "y": 8
         },
         "id": 3,
         "options": {
           "orientation": "auto",
           "reduceOptions": {
             "calcs": [
               "lastNotNull"
             ],
             "fields": "",
             "values": false
           },
           "showThresholdLabels": false,
           "showThresholdMarkers": true
         },
         "pluginVersion": "10.0.3",
         "title": "HTTP Status Codes",
         "type": "gauge"
       }
     ],
     "refresh": "5s",
     "schemaVersion": 38,
     "style": "dark",
     "tags": [],
     "templating": {
       "list": []
     },
     "time": {
       "from": "now-6h",
       "to": "now"
     },
     "timepicker": {},
     "timezone": "",
     "title": "Voting App Dashboard",
     "version": 0,
     "weekStart": ""
   }
   ```

3. **Import Dashboard**
   - Buka Grafana UI
   - Klik "+" → "Import"
   - Paste JSON di atas
   - Klik "Load"

### Monitoring Metrics

1. **Request Rate**
   ```promql
   rate(http_requests_total[5m])
   ```

2. **Backend Latency**
   ```promql
   histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
   ```

3. **HTTP Status Codes**
   ```promql
   sum by (status) (rate(http_requests_total[5m]))
   ```

### Alerting

1. **Setup Alert Rules**
   ```yaml
   # voting-alerts.yaml
   apiVersion: monitoring.coreos.com/v1
   kind: PrometheusRule
   metadata:
     name: voting-alerts
     namespace: monitoring
   spec:
     groups:
     - name: voting
       rules:
       - alert: HighErrorRate
         expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
         for: 5m
         labels:
           severity: critical
         annotations:
           summary: High error rate detected
           description: Error rate is above 10% for 5 minutes
   ```
   ```bash
   kubectl apply -f voting-alerts.yaml
   ```

2. **Konfigurasi Notifikasi**
   - Email
   - Slack
   - PagerDuty

### Best Practices Monitoring

1. **Metric Collection**
   - Collect metrics setiap 15 detik
   - Retain data selama 15 hari
   - Use appropriate retention policies

2. **Dashboard Design**
   - Group related metrics
   - Use appropriate visualizations
   - Set meaningful thresholds

3. **Alert Management**
   - Set meaningful thresholds
   - Avoid alert fatigue
   - Use proper severity levels

### Troubleshooting Monitoring

1. **Metrics Not Showing**
   - Check ServiceMonitor configuration
   - Verify metrics endpoints
   - Check Prometheus targets

2. **High Resource Usage**
   - Optimize scrape intervals
   - Adjust retention periods
   - Scale Prometheus if needed

3. **Alert Issues**
   - Check alert rules
   - Verify notification channels
   - Test alert conditions

### Kontak Support Monitoring

Jika mengalami masalah dengan monitoring:
- Email: monitoring@voting-app.com
- Slack: #monitoring-support
- Jam kerja: 24/7