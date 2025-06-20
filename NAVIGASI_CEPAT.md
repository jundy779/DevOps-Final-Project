# 🗺️ Navigasi Cepat - Voting App DevOps Project

## 📁 Struktur Folder

```
Final-DevOps/
├── 📖 README_SEDERHANA.md          # Panduan untuk awam
├── 📖 README.md                    # Dokumentasi lengkap
├── 🔧 setup-untuk-awam.ps1         # Setup script Windows
├── 🔧 setup-untuk-awam.sh          # Setup script Linux/macOS
├── 🚀 jalankan-aplikasi.ps1        # Run script Windows
├── 🚀 jalankan-aplikasi.sh         # Run script Linux/macOS
├── 🚀 jalankan-linux.bat           # Windows batch untuk Linux script
├── 🔧 TROUBLESHOOTING_CHEATSHEET.md # Solusi masalah cepat
├── 📚 docs/
│   ├── PANDUAN_LENGKAP_UNTUK_AWAM.md # Panduan detail
│   ├── architecture.md             # Arsitektur aplikasi
│   ├── api-dokumentasi.md          # Dokumentasi API
│   └── ...
├── 🐳 docker-compose.yml           # Docker Compose config
├── 🐳 frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
├── 🐳 backend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
├── ☸️ kubernetes/
│   ├── deploy.sh                   # Deploy script
│   ├── undeploy.sh                 # Undeploy script
│   ├── namespace.yaml
│   ├── secret.yaml
│   └── ...
├── 🔧 jenkins/
│   ├── Jenkinsfile                 # Pipeline config
│   ├── backend-pipeline.groovy
│   ├── frontend-pipeline.groovy
│   └── ...
└── 📊 monitoring/
    ├── docker-compose.yml          # Monitoring stack
    ├── grafana/
    ├── prometheus/
    └── ...
```

## 🚀 Cara Cepat Mulai

### Untuk Pemula (5 Menit)
1. **Baca**: `README_SEDERHANA.md`
2. **Setup**: Jalankan script setup sesuai OS
3. **Jalankan**: Gunakan script jalankan aplikasi
4. **Akses**: Buka browser ke http://localhost:3000

### Untuk Developer
1. **Setup**: `setup-untuk-awam.ps1` atau `setup-untuk-awam.sh`
2. **Docker**: `docker-compose up -d`
3. **Kubernetes**: `cd kubernetes && ./deploy.sh`
4. **Jenkins**: Setup pipeline dari `jenkins/Jenkinsfile`

## 📋 Script yang Tersedia

### Setup Scripts
| File | Platform | Fungsi |
|------|----------|--------|
| `setup-untuk-awam.ps1` | Windows | Install Docker, kubectl, minikube, Jenkins |
| `setup-untuk-awam.sh` | Linux/macOS | Install semua dependencies |
| `jalankan-linux.bat` | Windows | Jalankan script Linux di WSL/Git Bash |

### Run Scripts
| File | Platform | Fungsi |
|------|----------|--------|
| `jalankan-aplikasi.ps1` | Windows | Menu interaktif untuk menjalankan aplikasi |
| `jalankan-aplikasi.sh` | Linux/macOS | Menu interaktif untuk menjalankan aplikasi |

### Kubernetes Scripts
| File | Fungsi |
|------|--------|
| `kubernetes/deploy.sh` | Deploy aplikasi ke Kubernetes |
| `kubernetes/undeploy.sh` | Hapus aplikasi dari Kubernetes |

## 🎯 Pilihan Deployment

### 1. Docker Compose (Paling Mudah)
```bash
# Jalankan
docker-compose up -d

# Akses
# Frontend: http://localhost:3000
# Backend: http://localhost:8000
# Database: localhost:5432
```

### 2. Kubernetes (Production-like)
```bash
# Deploy
cd kubernetes
./deploy.sh

# Akses
kubectl port-forward service/frontend-service 3000:80 -n voting-app
kubectl port-forward service/backend-service 8000:8000 -n voting-app
```

### 3. Jenkins CI/CD
```bash
# Jalankan Jenkins
# Windows: java -jar C:\jenkins\jenkins.war --httpPort=8080
# Linux/macOS: ~/jenkins/start-jenkins.sh

# Akses: http://localhost:8080
# Import pipeline dari jenkins/Jenkinsfile
```

### 4. Monitoring
```bash
# Jalankan monitoring
cd monitoring
docker-compose up -d

# Akses
# Grafana: http://localhost:3001 (admin/admin)
# Prometheus: http://localhost:9090
```

## 🔧 Troubleshooting

### File Referensi
- **`TROUBLESHOOTING_CHEATSHEET.md`** - Solusi masalah umum
- **`docs/PANDUAN_LENGKAP_UNTUK_AWAM.md`** - Panduan detail dengan troubleshooting

### Command Cepat
```bash
# Cek status aplikasi
docker-compose ps
kubectl get pods -n voting-app

# Lihat logs
docker-compose logs
kubectl logs <pod-name> -n voting-app

# Restart aplikasi
docker-compose restart
kubectl rollout restart deployment/backend -n voting-app
```

## 📚 Dokumentasi

### Untuk Pemula
- **`README_SEDERHANA.md`** - Panduan singkat dan mudah
- **`docs/PANDUAN_LENGKAP_UNTUK_AWAM.md`** - Panduan detail step-by-step

### Untuk Developer
- **`docs/architecture.md`** - Arsitektur aplikasi
- **`docs/api-dokumentasi.md`** - Dokumentasi API
- **`kubernetes/README.md`** - Panduan Kubernetes
- **`jenkins/README.md`** - Panduan Jenkins

### Untuk DevOps Engineer
- **`docs/panduan-deployment.md`** - Panduan deployment
- **`docs/panduan-monitoring.md`** - Panduan monitoring
- **`docs/panduan-kubernetes.md`** - Panduan Kubernetes

## 🎮 Workflow Umum

### Development
1. Clone repository
2. Setup environment dengan script setup
3. Jalankan dengan Docker Compose
4. Develop dan test aplikasi
5. Commit dan push perubahan

### CI/CD
1. Setup Jenkins
2. Import pipeline dari `jenkins/Jenkinsfile`
3. Setup credentials (Docker Hub, kubeconfig)
4. Trigger build otomatis atau manual
5. Monitor deployment

### Production
1. Setup Kubernetes cluster
2. Deploy dengan `kubernetes/deploy.sh`
3. Setup monitoring dengan `monitoring/docker-compose.yml`
4. Monitor aplikasi dengan Grafana
5. Scale aplikasi sesuai kebutuhan

## 🆘 Butuh Bantuan?

### Urutan Bantuan
1. **Cek troubleshooting cheatsheet** - `TROUBLESHOOTING_CHEATSHEET.md`
2. **Baca panduan lengkap** - `docs/PANDUAN_LENGKAP_UNTUK_AWAM.md`
3. **Cek logs aplikasi** - `docker-compose logs` atau `kubectl logs`
4. **Google error message** - 90% masalah sudah ada solusinya
5. **Buat issue di GitHub** - Jika masalah belum ada solusinya

### Contact
- **Email**: [your-email@example.com]
- **GitHub Issues**: [repository-issues-url]
- **Documentation**: Folder `docs/`

---

**💡 Tip: Mulai dari `README_SEDERHANA.md` untuk pengalaman terbaik! 🚀** 