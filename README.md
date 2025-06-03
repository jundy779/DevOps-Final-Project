# Voting App - DevOps Project

Aplikasi voting sederhana dengan implementasi DevOps practices.

## Struktur Proyek

```
voting-app/
├── frontend/           # React frontend
├── backend/           # Node.js backend
├── docker/            # Docker configuration
├── kubernetes/        # Basic k8s configs
├── jenkins/           # Basic Jenkins pipeline
├── docker-compose.yml # Development environment
└── README.md
```

## Setup Development Environment

1. Install dependencies:
   ```bash
   # Backend
   cd backend
   npm install

   # Frontend
   cd frontend
   npm install
   ```

2. Run with Docker Compose:
   ```bash
   docker-compose up
   ```

## Deployment

### Local Kubernetes Deployment
```bash
kubectl apply -f kubernetes/
```

### Jenkins Pipeline
1. Setup Jenkins server
2. Create new pipeline job
3. Point to Jenkinsfile in repository

## Akses Aplikasi

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Jenkins: http://localhost:8080

## Tim

- Infrastructure Engineer: [Nama]
- CI/CD Engineer: [Nama]
- Deployment Engineer: [Nama]
- Monitoring Engineer: [Nama] 