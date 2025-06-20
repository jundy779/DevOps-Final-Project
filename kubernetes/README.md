# Voting App - Kubernetes Deployment

Dokumentasi ini menjelaskan cara menjalankan aplikasi Voting menggunakan kubectl.

## Prerequisites

1. **Kubernetes Cluster** - Pastikan Anda memiliki akses ke cluster Kubernetes
2. **kubectl** - Pastikan kubectl sudah terinstall dan terkonfigurasi
3. **Docker Registry** - Pastikan image Docker sudah di-push ke registry

## Struktur File

```
kubernetes/
├── namespace.yaml           # Namespace untuk aplikasi
├── secret.yaml             # Secret untuk kredensial database
├── postgres-deployment.yaml # Deployment PostgreSQL
├── backend-deployment.yaml  # Deployment Backend
├── frontend-deployment.yaml # Deployment Frontend
├── deploy.sh               # Script deployment otomatis
└── undeploy.sh             # Script undeployment otomatis
```

## Cara Menjalankan dengan kubectl

### 1. Deploy Manual (Step by Step)

```bash
# 1. Buat namespace
kubectl apply -f namespace.yaml

# 2. Buat secret untuk database
kubectl apply -f secret.yaml

# 3. Deploy PostgreSQL
kubectl apply -f postgres-deployment.yaml

# 4. Tunggu PostgreSQL siap
kubectl wait --for=condition=ready pod -l app=postgres -n voting-app --timeout=300s

# 5. Deploy Backend
kubectl apply -f backend-deployment.yaml

# 6. Deploy Frontend
kubectl apply -f frontend-deployment.yaml

# 7. Tunggu semua pod siap
kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=frontend -n voting-app --timeout=300s
```

### 2. Deploy Otomatis (Menggunakan Script)

```bash
# Deploy semua komponen
chmod +x deploy.sh
./deploy.sh

# Undeploy semua komponen
chmod +x undeploy.sh
./undeploy.sh
```

## Verifikasi Deployment

### Cek Status Pod
```bash
kubectl get pods -n voting-app
```

### Cek Status Service
```bash
kubectl get services -n voting-app
```

### Cek Logs
```bash
# Log backend
kubectl logs -f deployment/backend -n voting-app

# Log frontend
kubectl logs -f deployment/frontend -n voting-app

# Log database
kubectl logs -f deployment/postgres -n voting-app
```

### Akses Aplikasi

1. **Frontend**: Akses melalui LoadBalancer IP
   ```bash
   kubectl get service frontend-service -n voting-app
   ```

2. **Backend API**: Akses internal dari dalam cluster
   ```bash
   kubectl get service backend-service -n voting-app
   ```

## Troubleshooting

### Pod Tidak Ready
```bash
# Cek detail pod
kubectl describe pod <pod-name> -n voting-app

# Cek events
kubectl get events -n voting-app --sort-by='.lastTimestamp'
```

### Database Connection Error
```bash
# Cek secret
kubectl get secret voting-app-secret -n voting-app -o yaml

# Test koneksi database
kubectl run test-db --image=postgres:15-alpine -n voting-app --rm -i --restart=Never -- psql -h postgres-service -U voting_user -d voting_db
```

### Image Pull Error
```bash
# Cek image yang digunakan
kubectl describe deployment backend -n voting-app
kubectl describe deployment frontend -n voting-app
```

## Scaling

### Scale Backend
```bash
kubectl scale deployment backend --replicas=3 -n voting-app
```

### Scale Frontend
```bash
kubectl scale deployment frontend --replicas=3 -n voting-app
```

## Monitoring

### Cek Resource Usage
```bash
kubectl top pods -n voting-app
kubectl top nodes
```

### Cek Metrics
```bash
# Port forward ke backend untuk akses metrics
kubectl port-forward deployment/backend 8000:8000 -n voting-app

# Akses metrics di browser: http://localhost:8000/metrics
```

## Cleanup

### Hapus Semua Resource
```bash
kubectl delete namespace voting-app
```

### Hapus Selective
```bash
kubectl delete -f frontend-deployment.yaml
kubectl delete -f backend-deployment.yaml
kubectl delete -f postgres-deployment.yaml
```

## Konfigurasi Environment

### Update Image Tag
```bash
# Update image tag di deployment
kubectl set image deployment/backend backend=your-registry.com/voting-app-backend:v1.2.0 -n voting-app
kubectl set image deployment/frontend frontend=your-registry.com/voting-app-frontend:v1.2.0 -n voting-app
```

### Update Environment Variables
```bash
# Update environment variable
kubectl set env deployment/backend NODE_ENV=production -n voting-app
```

## Security Notes

1. **Secrets**: Kredensial database disimpan dalam Kubernetes Secrets
2. **Network Policy**: Pertimbangkan untuk menambahkan Network Policy untuk isolasi
3. **RBAC**: Pastikan menggunakan Role-Based Access Control yang tepat
4. **Image Security**: Gunakan image yang sudah di-scan untuk vulnerabilities

## Best Practices

1. **Resource Limits**: Selalu set resource requests dan limits
2. **Health Checks**: Gunakan liveness dan readiness probes
3. **Rolling Updates**: Gunakan rolling update strategy untuk zero-downtime deployment
4. **Backup**: Backup data PostgreSQL secara berkala
5. **Monitoring**: Setup monitoring dan alerting untuk aplikasi 