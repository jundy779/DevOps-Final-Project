# CI/CD Pipeline dengan Jenkins

## 📋 Overview

Pipeline CI/CD untuk aplikasi Voting menggunakan Jenkins dengan fitur:
- ✅ Code Quality Check (Linting)
- ✅ Unit Testing dengan Coverage
- ✅ Security Scan
- ✅ Docker Image Building
- ✅ Load Testing dengan k6
- ✅ Multi-environment Deployment (Staging & Production)
- ✅ Health Check
- ✅ Email Notifications

## 🚀 Setup Jenkins

### 1. Install Jenkins
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

# CentOS/RHEL
sudo yum install java-11-openjdk-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins
```

### 2. Start Jenkins
```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### 3. Get Initial Password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 4. Install Required Plugins
```bash
chmod +x jenkins/setup-jenkins.sh
./jenkins/setup-jenkins.sh
```

## 🔧 Konfigurasi Pipeline

### 1. Create New Pipeline Job
1. Buka Jenkins UI (http://localhost:8080)
2. Klik "New Item"
3. Pilih "Pipeline"
4. Masukkan nama: "voting-app-pipeline"

### 2. Configure Pipeline
1. **General Settings:**
   - ✅ GitHub project: `https://github.com/your-username/voting-app/`
   - ✅ This project is parameterized
   - ✅ Build Triggers: GitHub hook trigger for GITScm polling

2. **Pipeline Definition:**
   - ✅ Pipeline script from SCM
   - ✅ SCM: Git
   - Repository URL: `https://github.com/your-username/voting-app.git`
   - Script Path: `jenkins/Jenkinsfile`

### 3. Set Up Credentials
1. **Docker Registry Credentials:**
   - Kind: Username with password
   - ID: `docker-registry-credentials`
   - Username: your-docker-username
   - Password: your-docker-password

2. **Kubernetes Credentials:**
   - Kind: Secret file
   - ID: `kubeconfig`
   - File: Upload your kubeconfig file

3. **GitHub Credentials:**
   - Kind: SSH Username with private key
   - ID: `github-ssh`
   - Username: git
   - Private Key: Your SSH private key

## 📊 Pipeline Stages

### 1. Checkout
- Clone repository dari Git
- Checkout branch yang sesuai

### 2. Code Quality Check
- Linting untuk JavaScript/Node.js
- Code style validation

### 3. Install Dependencies
- Install dependencies backend dan frontend secara parallel
- Menggunakan `npm ci` untuk konsistensi

### 4. Run Tests
- Unit tests untuk backend dan frontend
- Coverage reporting
- JUnit XML reports

### 5. Security Scan
- npm audit untuk vulnerability check
- Security scanning

### 6. Build Docker Images
- Build backend dan frontend images secara parallel
- Tag dengan build number dan latest

### 7. Push Docker Images
- Push images ke registry (hanya untuk branch main)
- Menggunakan credentials yang sudah dikonfigurasi

### 8. Load Testing
- Load testing dengan k6
- Performance validation

### 9. Deploy to Staging
- Deploy ke staging environment (branch develop)
- Kubernetes deployment

### 10. Deploy to Production
- Deploy ke production environment (branch main)
- Kubernetes deployment

### 11. Health Check
- Verify aplikasi berjalan dengan baik
- Health endpoint check

## 🔄 Branch Strategy

### Main Branch
- ✅ Automatic deployment ke production
- ✅ Push Docker images ke registry
- ✅ Full testing dan security scan

### Develop Branch
- ✅ Automatic deployment ke staging
- ✅ Testing dan validation
- ✅ No production deployment

### Feature Branches
- ✅ Testing dan validation
- ✅ No deployment

## 📧 Notifications

### Email Notifications
- ✅ Success notifications dengan detail build
- ✅ Failure notifications dengan error info
- ✅ HTML formatted emails

### Slack Notifications (Optional)
```groovy
// Add to Jenkinsfile
slackSend(
    channel: '#devops',
    color: 'good',
    message: "Build ${currentBuild.fullDisplayName} successful!"
)
```

## 🛠️ Troubleshooting

### Common Issues

1. **Docker Permission Denied**
```bash
sudo usermod -a -G docker jenkins
sudo systemctl restart jenkins
```

2. **Kubernetes Access Denied**
```bash
# Copy kubeconfig to Jenkins home
sudo cp ~/.kube/config /var/lib/jenkins/.kube/
sudo chown jenkins:jenkins /var/lib/jenkins/.kube/config
```

3. **GitHub Webhook Issues**
- Pastikan webhook URL: `http://jenkins-url/github-webhook/`
- Set up GitHub credentials di Jenkins

4. **Email Notifications Not Working**
- Configure SMTP settings di Jenkins
- Test email configuration

## 📈 Monitoring

### Build Metrics
- Build success/failure rate
- Build duration
- Test coverage trends

### Pipeline Analytics
- Stage execution time
- Failure points
- Performance bottlenecks

## 🔐 Security Best Practices

1. **Credentials Management**
   - Gunakan Jenkins Credentials Provider
   - Jangan hardcode credentials di Jenkinsfile
   - Rotate credentials secara berkala

2. **Access Control**
   - Set up role-based access control
   - Limit pipeline execution permissions
   - Audit build logs

3. **Container Security**
   - Scan Docker images untuk vulnerabilities
   - Use minimal base images
   - Implement image signing

## 📚 Additional Resources

- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [Kubernetes Plugin](https://plugins.jenkins.io/kubernetes/)
- [Blue Ocean UI](https://www.jenkins.io/doc/book/blueocean/) 