# Voting App - Final DevOps Project

Aplikasi voting sederhana yang diimplementasikan dengan arsitektur microservices menggunakan Docker, Kubernetes, dan Jenkins CI/CD.

## 🚀 Fitur Utama

- **Frontend**: Interface voting yang responsif dengan Bootstrap
- **Backend**: API REST dengan Express.js dan PostgreSQL
- **Database**: PostgreSQL dengan persistent storage
- **Containerization**: Docker untuk semua komponen
- **Orchestration**: Kubernetes untuk deployment produksi
- **CI/CD**: Jenkins pipeline dengan multi-job build
- **Monitoring**: Prometheus dan Grafana untuk observabilitas

## 📋 Prerequisites

- Docker dan Docker Compose
- Kubernetes cluster (minikube, kind, atau cloud provider)
- kubectl CLI tool
- Jenkins server (untuk CI/CD)

## 🏗️ Arsitektur

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │    │   Backend   │    │ PostgreSQL  │
│   (Port 80) │◄──►│  (Port 8000)│◄──►│  (Port 5432)│
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌─────────────┐
                    │ Kubernetes  │
                    │   Cluster   │
                    └─────────────┘
```

## 🚀 Cara Menjalankan

### 1. Menggunakan Docker Compose (Development)

```bash
# Clone repository
git clone <repository-url>
cd Final-DevOps

# Jalankan aplikasi
docker-compose up -d

# Akses aplikasi
# Frontend: http://localhost:3000
# Backend API: http://localhost:8000
# Database: localhost:5432
```

### 2. Menggunakan kubectl (Production)

```bash
# Deploy ke Kubernetes
cd kubernetes
chmod +x deploy.sh
./deploy.sh

# Cek status deployment
kubectl get pods -n voting-app
kubectl get services -n voting-app

# Akses aplikasi melalui LoadBalancer IP
kubectl get service frontend-service -n voting-app
```

### 3. Undeploy dari Kubernetes

```bash
cd kubernetes
chmod +x undeploy.sh
./undeploy.sh
```

## 🔧 Konfigurasi

### Environment Variables

**Backend:**
- `DB_HOST`: Host database (default: postgres-service)
- `DB_USER`: Username database (dari Kubernetes Secret)
- `DB_PASSWORD`: Password database (dari Kubernetes Secret)
- `DB_NAME`: Nama database (default: voting_db)
- `DB_PORT`: Port database (default: 5432)
- `NODE_ENV`: Environment (development/production)

### Kubernetes Secrets

```bash
# Secret untuk database credentials
kubectl get secret voting-app-secret -n voting-app -o yaml
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm install
npm test
```

### Frontend Tests
```bash
cd frontend
npm install
npm test
```

### Integration Tests
```bash
# Test API endpoints
curl http://localhost:8000/health
curl http://localhost:8000/api/votes
curl -X POST http://localhost:8000/api/votes \
  -H "Content-Type: application/json" \
  -d '{"candidate_id": 1}'
```

## 📊 Monitoring

### Prometheus Metrics
```bash
# Akses metrics endpoint
curl http://localhost:8000/metrics

# Port forward untuk akses dari luar cluster
kubectl port-forward deployment/backend 8000:8000 -n voting-app
```

### Grafana Dashboard
```bash
# Deploy monitoring stack
cd monitoring
docker-compose up -d

# Akses Grafana
# URL: http://localhost:3001
# Username: admin
# Password: admin
```

## 🔄 CI/CD Pipeline

### Jenkins Multi-Job Pipeline

Pipeline Jenkins yang telah dikonfigurasi mencakup:

1. **Checkout**: Mengambil kode dari repository
2. **Parallel Build**: Build frontend dan backend secara paralel
3. **Push Images**: Push Docker images ke registry
4. **Deploy to Kubernetes**: Deploy ke cluster Kubernetes
5. **Integration Test**: Test integrasi aplikasi

### Konfigurasi Jenkins

1. **Credentials**: Setup kubeconfig dan Docker registry credentials
2. **Pipeline**: Import `jenkins/Jenkinsfile`
3. **Triggers**: SCM polling setiap 5 menit

### Manual Trigger

```bash
# Build dan deploy manual
curl -X POST http://jenkins-url/job/voting-app/build \
  --user username:api-token
```

## 🔍 Troubleshooting

### Pod Tidak Ready
```bash
# Cek detail pod
kubectl describe pod <pod-name> -n voting-app

# Cek logs
kubectl logs <pod-name> -n voting-app
```

### Database Connection Issues
```bash
# Test koneksi database
kubectl run test-db --image=postgres:15-alpine -n voting-app \
  --rm -i --restart=Never -- \
  psql -h postgres-service -U voting_user -d voting_db
```

### Service Tidak Aksesible
```bash
# Cek service endpoints
kubectl get endpoints -n voting-app

# Test service dari dalam cluster
kubectl run test-curl --image=curlimages/curl -n voting-app \
  --rm -i --restart=Never -- \
  curl http://backend-service:8000/health
```

## 📈 Scaling

### Horizontal Pod Autoscaling
```bash
# Scale backend
kubectl scale deployment backend --replicas=3 -n voting-app

# Scale frontend
kubectl scale deployment frontend --replicas=3 -n voting-app
```

### Resource Management
```bash
# Cek resource usage
kubectl top pods -n voting-app
kubectl top nodes
```

## 🔒 Security

- **Secrets Management**: Kredensial database disimpan dalam Kubernetes Secrets
- **Network Policies**: Isolasi network antar komponen
- **Image Security**: Scan vulnerabilities pada Docker images
- **RBAC**: Role-based access control untuk Kubernetes

## 📚 Dokumentasi Tambahan

- [Arsitektur Detail](docs/architecture.md)
- [API Documentation](docs/api-dokumentasi.md)
- [Deployment Guide](docs/panduan-deployment.md)
- [Monitoring Setup](docs/panduan-monitoring.md)
- [Kubernetes Guide](kubernetes/README.md)

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Support

Untuk pertanyaan atau dukungan, silakan buat issue di repository ini. 