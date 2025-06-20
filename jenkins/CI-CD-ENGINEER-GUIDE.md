# CI/CD Engineer Guide - Multi-Job Pipeline

## 🎯 **Tugas Utama: Build Pipeline Terpisah untuk Frontend dan Backend**

### **Overview**
Sebagai CI/CD Engineer, Anda bertanggung jawab untuk membuat dan mengelola pipeline yang terpisah untuk frontend dan backend dengan integrasi multi-job di Jenkins.

## 📋 **Struktur Pipeline**

### **1. Pipeline Terpisah**
- **Frontend Pipeline**: `jenkins/frontend-pipeline.groovy`
- **Backend Pipeline**: `jenkins/backend-pipeline.groovy`
- **Multi-Job Pipeline**: `jenkins/multi-job-pipeline.groovy`

### **2. Karakteristik Pipeline**

#### **Frontend Pipeline:**
- ✅ Install dependencies (npm install)
- ✅ Lint & format code
- ✅ Unit tests dengan coverage
- ✅ Build production bundle
- ✅ Docker image build
- ✅ Push ke registry
- ✅ Deploy ke staging/production

#### **Backend Pipeline:**
- ✅ Install dependencies (npm install)
- ✅ Code quality checks
- ✅ Unit tests dengan coverage
- ✅ Security scan
- ✅ Docker image build
- ✅ Push ke registry
- ✅ Deploy ke staging/production
- ✅ Integration tests

#### **Multi-Job Pipeline:**
- ✅ Parallel execution frontend & backend
- ✅ Conditional deployment berdasarkan branch
- ✅ Integration testing
- ✅ Production health checks

## 🚀 **Setup Jenkins Jobs**

### **Step 1: Install Required Plugins**
```
1. Pipeline
2. Docker Pipeline
3. Kubernetes
4. Git
5. Credentials Binding
6. HTML Publisher
7. JUnit
8. Blue Ocean (optional)
```

### **Step 2: Setup Credentials**
```
1. Docker Registry: docker-registry
   - Username: your-registry-username
   - Password: your-registry-password

2. GitHub: github-credentials
   - Username: your-github-username
   - Password/Token: your-github-token

3. Kubernetes: kubeconfig
   - Kubeconfig file untuk akses cluster
```

### **Step 3: Create Jobs**

#### **Job 1: Frontend Pipeline**
```
Name: voting-app-frontend-pipeline
Type: Pipeline
Script Path: jenkins/frontend-pipeline.groovy
Triggers: SCM Polling (H/5 * * * *)
```

#### **Job 2: Backend Pipeline**
```
Name: voting-app-backend-pipeline
Type: Pipeline
Script Path: jenkins/backend-pipeline.groovy
Triggers: SCM Polling (H/5 * * * *)
```

#### **Job 3: Multi-Job Pipeline**
```
Name: voting-app-multi-pipeline
Type: Pipeline
Script Path: jenkins/multi-job-pipeline.groovy
Triggers: 
- SCM Polling (H/5 * * * *)
- GitHub Push Trigger
Parameters:
- BRANCH (default: develop)
- SKIP_TESTS (default: false)
- SKIP_DEPLOY (default: false)
- DEPLOY_ENVIRONMENT (staging/production)
```

## 🔧 **Pipeline Configuration**

### **Environment Variables**
```groovy
environment {
    DOCKER_REGISTRY = 'your-registry.com'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    FRONTEND_IMAGE = 'voting-app-frontend'
    BACKEND_IMAGE = 'voting-app-backend'
}
```

### **Branch Strategy**
```groovy
// develop branch -> staging environment
// main branch -> production environment
when {
    branch 'develop'
    // Deploy to staging
}
when {
    branch 'main'
    // Deploy to production
}
```

### **Parallel Execution**
```groovy
stage('Parallel Build & Test') {
    parallel {
        stage('Frontend Pipeline') {
            // Frontend build steps
        }
        stage('Backend Pipeline') {
            // Backend build steps
        }
    }
}
```

## 📊 **Monitoring & Reporting**

### **Test Reports**
- **Coverage Reports**: HTML publisher untuk test coverage
- **JUnit Reports**: Test results dalam format XML
- **Security Reports**: npm audit results

### **Build Metrics**
- **Build Duration**: Tracking waktu build
- **Success Rate**: Persentase build success
- **Test Coverage**: Coverage percentage

### **Deployment Status**
- **Rollout Status**: Kubernetes deployment status
- **Health Checks**: Application health monitoring
- **Integration Tests**: End-to-end testing

## 🔒 **Security & Best Practices**

### **Security Measures**
1. **Credentials Management**: Gunakan Jenkins credentials
2. **Image Scanning**: Scan Docker images untuk vulnerabilities
3. **Access Control**: RBAC untuk Jenkins dan Kubernetes
4. **Audit Logging**: Log semua pipeline activities

### **Best Practices**
1. **Fail Fast**: Pipeline berhenti jika ada error
2. **Idempotent**: Pipeline bisa dijalankan berulang kali
3. **Rollback Strategy**: Kemampuan rollback jika deployment gagal
4. **Resource Limits**: Set resource limits untuk builds

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **1. Docker Build Failures**
```bash
# Check Docker daemon
sudo systemctl status docker

# Check Docker permissions
sudo usermod -aG docker jenkins
```

#### **2. Kubernetes Deployment Failures**
```bash
# Check cluster access
kubectl cluster-info

# Check namespace
kubectl get namespaces

# Check pod status
kubectl get pods -n voting-app
```

#### **3. Test Failures**
```bash
# Check test logs
kubectl logs <pod-name> -n voting-app

# Check test coverage
cat coverage/lcov-report/index.html
```

### **Debug Commands**
```bash
# Check Jenkins logs
sudo journalctl -u jenkins -f

# Check pipeline logs
# Via Jenkins web interface: Build -> Console Output

# Check Docker images
docker images | grep voting-app

# Check Kubernetes resources
kubectl get all -n voting-app
```

## 📈 **Performance Optimization**

### **Build Optimization**
1. **Docker Layer Caching**: Optimize Dockerfile
2. **Parallel Execution**: Build frontend dan backend bersamaan
3. **Resource Allocation**: Set appropriate CPU/memory limits
4. **Cleanup**: Regular cleanup of old builds and images

### **Deployment Optimization**
1. **Rolling Updates**: Zero-downtime deployments
2. **Health Checks**: Proper liveness dan readiness probes
3. **Resource Limits**: Set Kubernetes resource limits
4. **Auto-scaling**: HPA untuk scaling otomatis

## 🎯 **Success Metrics**

### **Pipeline Metrics**
- ✅ **Build Success Rate**: >95%
- ✅ **Test Coverage**: >80%
- ✅ **Deployment Success Rate**: >98%
- ✅ **Mean Time to Recovery**: <30 minutes

### **Quality Gates**
- ✅ All tests must pass
- ✅ Coverage must be above threshold
- ✅ Security scan must pass
- ✅ Integration tests must pass

## 📚 **Additional Resources**

### **Jenkins Documentation**
- [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Docker Pipeline](https://www.jenkins.io/doc/book/pipeline/docker/)
- [Kubernetes Plugin](https://plugins.jenkins.io/kubernetes/)

### **Best Practices**
- [Jenkins Best Practices](https://www.jenkins.io/doc/book/pipeline/practices/)
- [CI/CD Best Practices](https://www.jenkins.io/doc/book/pipeline/practices/)

## 🚀 **Quick Start Commands**

```bash
# 1. Setup Jenkins (if not already done)
sudo systemctl start jenkins
sudo systemctl enable jenkins

# 2. Get admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# 3. Access Jenkins
# Open: http://your-server:8080

# 4. Install plugins and setup credentials

# 5. Create pipeline jobs using the provided groovy files

# 6. Test pipeline
# Trigger build manually or push to repository
```

---

**Note**: Pastikan untuk mengganti placeholder values seperti `your-registry.com`, `your-github-username`, dll. dengan nilai yang sesuai dengan environment Anda. 