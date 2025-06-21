# Panduan Deployment

## Deployment dengan Docker Compose

### 1. Build dan Jalankan
```bash
# Build images
docker-compose build

# Jalankan container
docker-compose up -d
```

### 2. Verifikasi
```bash
# Cek status container
docker-compose ps
```

## Deployment dengan Kubernetes

### 1. Deploy Aplikasi
```bash
# Deploy semua komponen
kubectl apply -f kubernetes/

# Cek status
kubectl get pods
```

### 2. Akses Aplikasi
```bash
# Port forward untuk frontend
kubectl port-forward service/frontend-service 3000:80

# Port forward untuk backend
kubectl port-forward service/backend-service 8000:8000
```

## Troubleshooting

### 1. Container Tidak Bisa Start
- Cek logs: `docker-compose logs`
- Restart container: `docker-compose restart`

### 2. Aplikasi Tidak Bisa Diakses
- Cek port yang digunakan
- Pastikan container sudah running 