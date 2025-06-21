#!/bin/bash

# Create necessary directories
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/provisioning/dashboards
mkdir -p grafana/dashboards

# Deploy monitoring stack
docker-compose up -d

echo "Monitoring stack deployed!"
echo "Access Prometheus at: http://localhost:9090"
echo "Access Grafana at: http://localhost:3001"
echo "Grafana default credentials:"
echo "Username: admin"
echo "Password: admin" 