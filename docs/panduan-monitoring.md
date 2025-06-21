# Panduan Monitoring

## Metrik Dasar

### 1. Metrik Aplikasi
- Status aplikasi (running/stopped)
- Jumlah request

### 2. Metrik Infrastruktur
- CPU usage
- Memory usage

## Tools Monitoring

### 1. Kubernetes Dashboard
```bash
# Akses dashboard
kubectl proxy
# Buka http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

### 2. Container Logs
```bash
# Logs untuk semua container
docker-compose logs

# Logs untuk container spesifik
docker-compose logs frontend
docker-compose logs backend
```

## Troubleshooting

### 1. Aplikasi Tidak Berjalan
- Cek status container: `docker-compose ps`
- Cek logs: `docker-compose logs`

### 2. Error pada Aplikasi
- Cek logs aplikasi
- Restart container jika diperlukan 