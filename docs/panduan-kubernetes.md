# Panduan Kubernetes

## Prasyarat
- Kubernetes cluster (minikube, kind, atau cluster produksi)
- kubectl terinstall
- Docker terinstall

## Struktur Deployment

### 1. Namespace
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: voting-app
```

### 2. ConfigMap & Secret
```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: voting-app-config
  namespace: voting-app
data:
  DB_HOST: "postgres-service"
  DB_PORT: "5432"
  DB_NAME: "voting_db"
---
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: voting-app-secret
  namespace: voting-app
type: Opaque
data:
  DB_USER: dm90aW5nX3VzZXI=  # voting_user
  DB_PASSWORD: dm90aW5nX3Bhc3M=  # voting_pass
```

### 3. Database (PostgreSQL)
```yaml
# postgres-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: voting-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:13
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_DB
          value: voting_db
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: voting-app-secret
              key: DB_USER
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: voting-app-secret
              key: DB_PASSWORD
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
---
# postgres-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
  namespace: voting-app
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
---
# postgres-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: voting-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### 4. Backend API
```yaml
# backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: voting-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: voting-app-backend:latest
        ports:
        - containerPort: 8000
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: voting-app-config
              key: DB_HOST
        - name: DB_PORT
          valueFrom:
            configMapKeyRef:
              name: voting-app-config
              key: DB_PORT
        - name: DB_NAME
          valueFrom:
            configMapKeyRef:
              name: voting-app-config
              key: DB_NAME
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: voting-app-secret
              key: DB_USER
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: voting-app-secret
              key: DB_PASSWORD
---
# backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: voting-app
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8000
```

### 5. Frontend
```yaml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: voting-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: voting-app-frontend:latest
        ports:
        - containerPort: 80
---
# frontend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: voting-app
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
```

### 6. Ingress
```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: voting-app-ingress
  namespace: voting-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: voting-app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
```

## Langkah Deployment

1. **Persiapkan Environment**
```bash
# Buat namespace
kubectl apply -f namespace.yaml

# Buat ConfigMap dan Secret
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
```

2. **Deploy Database**
```bash
# Buat PVC
kubectl apply -f postgres-pvc.yaml

# Deploy PostgreSQL
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml

# Tunggu database siap
kubectl wait --for=condition=ready pod -l app=postgres -n voting-app
```

3. **Deploy Backend**
```bash
# Build dan push image backend
docker build -t voting-app-backend:latest ./backend
docker push voting-app-backend:latest

# Deploy backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

4. **Deploy Frontend**
```bash
# Build dan push image frontend
docker build -t voting-app-frontend:latest ./frontend
docker push voting-app-frontend:latest

# Deploy frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

5. **Setup Ingress**
```bash
# Deploy ingress
kubectl apply -f ingress.yaml

# Tambahkan host ke /etc/hosts
echo "127.0.0.1 voting-app.local" | sudo tee -a /etc/hosts
```

## Verifikasi Deployment

1. **Cek Status Pod**
```bash
kubectl get pods -n voting-app
```

2. **Cek Services**
```bash
kubectl get services -n voting-app
```

3. **Cek Ingress**
```bash
kubectl get ingress -n voting-app
```

4. **Test Aplikasi**
```bash
# Test frontend
curl http://voting-app.local

# Test backend
curl http://voting-app.local/api/votes
```

## Troubleshooting

1. **Cek Log Pod**
```bash
# Backend
kubectl logs -f deployment/backend -n voting-app

# Frontend
kubectl logs -f deployment/frontend -n voting-app

# Database
kubectl logs -f deployment/postgres -n voting-app
```

2. **Cek Status Deployment**
```bash
kubectl describe deployment -n voting-app
```

3. **Cek Events**
```bash
kubectl get events -n voting-app
```

4. **Masalah Umum**
- Pod tidak mau start: Cek ConfigMap dan Secret
- Database connection error: Cek service name dan credentials
- Ingress tidak berfungsi: Cek annotations dan host configuration

## Scaling

1. **Scale Up/Down Deployment**
```bash
# Scale backend
kubectl scale deployment backend -n voting-app --replicas=3

# Scale frontend
kubectl scale deployment frontend -n voting-app --replicas=3
```

2. **Autoscaling**
```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
  namespace: voting-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: backend
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
```

## Backup & Restore

1. **Backup Database**
```bash
# Backup
kubectl exec -n voting-app deployment/postgres -- pg_dump -U voting_user voting_db > backup.sql

# Restore
kubectl exec -i -n voting-app deployment/postgres -- psql -U voting_user voting_db < backup.sql
```

2. **Backup PVC**
```bash
# Backup
kubectl cp voting-app/postgres-pod:/var/lib/postgresql/data ./backup-data

# Restore
kubectl cp ./backup-data voting-app/postgres-pod:/var/lib/postgresql/data
``` 