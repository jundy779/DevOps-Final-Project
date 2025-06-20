# 🔧 Troubleshooting Cheatsheet - Voting App DevOps

## 🚨 Masalah Umum & Solusi Cepat

### 1. Docker Issues

#### ❌ "Docker tidak ditemukan"
```bash
# Windows
# Download dari: https://www.docker.com/products/docker-desktop/

# Linux
sudo apt-get update
sudo apt-get install docker.io
sudo usermod -aG docker $USER
# Logout & login lagi

# macOS
brew install --cask docker
```

#### ❌ "Cannot connect to Docker daemon"
```bash
# Windows
# Pastikan Docker Desktop running

# Linux
sudo systemctl start docker
sudo systemctl enable docker

# macOS
# Buka Docker Desktop app
```

#### ❌ "Port already in use"
```bash
# Cek port yang digunakan
netstat -tulpn | grep :3000
netstat -tulpn | grep :8000

# Stop container yang menggunakan port
docker-compose down
docker stop $(docker ps -q)
```

### 2. Kubernetes Issues

#### ❌ "kubectl tidak ditemukan"
```bash
# Windows
choco install kubernetes-cli

# Linux/macOS
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

#### ❌ "minikube tidak ditemukan"
```bash
# Windows
choco install minikube

# Linux/macOS
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

#### ❌ "Pod tidak ready"
```bash
# Cek detail pod
kubectl describe pod <pod-name> -n voting-app

# Cek logs
kubectl logs <pod-name> -n voting-app

# Cek events
kubectl get events -n voting-app --sort-by='.lastTimestamp'
```

### 3. Jenkins Issues

#### ❌ "Java tidak ditemukan"
```bash
# Windows
choco install openjdk11

# Linux
sudo apt-get install openjdk-11-jdk

# macOS
brew install openjdk@11
```

#### ❌ "Jenkins tidak bisa diakses"
```bash
# Cek apakah Jenkins running
ps aux | grep jenkins

# Restart Jenkins
# Windows: Kill process Java
# Linux/macOS: pkill -f jenkins.war

# Cek port 8080
netstat -tulpn | grep :8080
```

#### ❌ "Password Jenkins tidak ditemukan"
```bash
# Windows
type C:\Users\%USERNAME%\.jenkins\secrets\initialAdminPassword

# Linux/macOS
cat ~/.jenkins/secrets/initialAdminPassword
```

### 4. Application Issues

#### ❌ "Aplikasi tidak bisa dibuka"
```bash
# Cek container status
docker-compose ps

# Lihat logs
docker-compose logs

# Restart aplikasi
docker-compose restart

# Test koneksi
curl http://localhost:8000/health
curl http://localhost:3000
```

#### ❌ "Database connection error"
```bash
# Test koneksi database
docker exec -it <postgres-container> psql -U voting_user -d voting_db

# Cek environment variables
docker-compose exec backend env | grep DB_
```

#### ❌ "Frontend tidak load"
```bash
# Cek apakah frontend container running
docker-compose ps frontend

# Lihat logs frontend
docker-compose logs frontend

# Cek network connectivity
docker-compose exec frontend curl http://backend:8000/health
```

### 5. Monitoring Issues

#### ❌ "Grafana tidak bisa diakses"
```bash
# Cek container status
cd monitoring
docker-compose ps

# Restart monitoring stack
docker-compose restart

# Cek logs
docker-compose logs grafana
```

#### ❌ "Prometheus tidak scrape metrics"
```bash
# Cek target status
curl http://localhost:9090/api/v1/targets

# Cek metrics endpoint
curl http://localhost:8000/metrics
```

### 6. Script Issues

#### ❌ "Permission denied pada script"
```bash
# Linux/macOS
chmod +x setup-untuk-awam.sh
chmod +x jalankan-aplikasi.sh

# Windows PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### ❌ "Script tidak ditemukan"
```bash
# Pastikan berada di folder yang benar
ls -la *.sh *.ps1

# Clone repository lagi jika perlu
git clone <repository-url>
cd Final-DevOps
```

## 🔍 Debug Commands

### Docker Debug
```bash
# Cek semua container
docker ps -a

# Cek images
docker images

# Cek networks
docker network ls

# Cek volumes
docker volume ls

# Clean up
docker system prune -a
```

### Kubernetes Debug
```bash
# Cek semua resources
kubectl get all -n voting-app

# Cek nodes
kubectl get nodes

# Cek services
kubectl get services -n voting-app

# Cek endpoints
kubectl get endpoints -n voting-app

# Port forward untuk test
kubectl port-forward service/backend-service 8000:8000 -n voting-app
```

### Network Debug
```bash
# Test koneksi
curl -v http://localhost:8000/health
telnet localhost 8000

# Cek port yang digunakan
lsof -i :3000
lsof -i :8000
lsof -i :8080

# Test DNS
nslookup backend-service
```

## 🚀 Quick Fixes

### Reset Everything
```bash
# Stop semua
docker-compose down
kubectl delete namespace voting-app --ignore-not-found=true
pkill -f jenkins.war

# Clean up
docker system prune -a
docker volume prune

# Start fresh
docker-compose up -d
```

### Rebuild Images
```bash
# Rebuild semua images
docker-compose build --no-cache

# Rebuild specific service
docker-compose build backend
docker-compose build frontend
```

### Reset Kubernetes
```bash
# Delete dan recreate namespace
kubectl delete namespace voting-app
kubectl create namespace voting-app

# Redeploy
cd kubernetes
./deploy.sh
```

## 📞 Emergency Contacts

### Error Messages
- **"Connection refused"** → Service tidak running
- **"Permission denied"** → Masalah hak akses
- **"Port already in use"** → Port terpakai aplikasi lain
- **"Image not found"** → Image belum di-build
- **"No space left on device"** → Disk penuh

### Quick Solutions
1. **Restart komputer** → Solusi untuk banyak masalah
2. **Update software** → Docker, kubectl, dll
3. **Check logs** → Selalu lihat logs untuk error detail
4. **Google error** → 90% masalah sudah ada solusinya di internet

## 🎯 Pro Tips

### Performance
```bash
# Monitor resource usage
docker stats
kubectl top pods -n voting-app

# Optimize Docker
docker system prune
docker builder prune
```

### Security
```bash
# Scan images
docker scan <image-name>

# Update base images
docker-compose pull
```

### Backup
```bash
# Backup database
docker-compose exec postgres pg_dump -U voting_user voting_db > backup.sql

# Backup configs
tar -czf config-backup.tar.gz kubernetes/ monitoring/
```

---

**💡 Remember: When in doubt, restart everything! 🔄** 