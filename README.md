# Online Voting Application - DevOps Project

## Project Overview
This repository contains a simple online voting application deployed on Kubernetes, featuring separate frontend and backend services with monitoring capabilities.

## Architecture
```
.
├── frontend/                 # React-based voting interface
├── backend/                  # Node.js/Express API service
├── k8s/                     # Kubernetes manifests
│   ├── frontend/           # Frontend deployment configs
│   ├── backend/            # Backend deployment configs
│   ├── monitoring/         # Prometheus & Grafana configs
│   └── ingress/            # Ingress configurations
├── jenkins/                # CI/CD pipeline configurations
└── monitoring/             # Grafana dashboards & Prometheus rules
```

## Prerequisites
- Kubernetes cluster
- Jenkins
- Docker
- kubectl
- Helm (for monitoring stack)

## Components
1. Frontend Service
   - React-based web application
   - Serves voting interface
   - Communicates with backend API

2. Backend Service
   - RESTful API service
   - Handles voting logic
   - Database integration

3. Monitoring Stack
   - Prometheus for metrics collection
   - Grafana for visualization
   - Metrics tracked:
     - Request rate
     - API latency
     - HTTP status codes (200/500)

## Getting Started
1. Clone this repository
2. Setup Kubernetes cluster
3. Deploy monitoring stack
4. Run CI/CD pipelines
5. Deploy applications

## Team Roles
- Project Lead: Frontend/backend module division, pod architecture
- Infrastructure Engineer: Kubernetes setup, namespace & ingress configuration
- CI/CD Engineer: Jenkins pipeline setup for frontend & backend
- Deployment Engineer: Service & deployment configuration
- Monitoring Engineer: Grafana dashboard creation

## Monitoring Metrics
- Request rate per endpoint
- Backend API latency
- HTTP status code distribution
- Pod health status
- Resource utilization

## Contributing
Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details 