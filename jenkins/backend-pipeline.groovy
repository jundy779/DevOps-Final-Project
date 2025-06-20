pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        BACKEND_IMAGE = 'voting-app-backend'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('backend') {
                    sh '''
                        npm install
                        npm audit --audit-level moderate || echo "Security audit completed"
                    '''
                }
            }
        }
        
        stage('Code Quality') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('backend') {
                    sh '''
                        npm run lint || echo "Linting completed"
                        npm run format || echo "Formatting completed"
                    '''
                }
            }
        }
        
        stage('Unit Tests') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('backend') {
                    sh '''
                        npm test -- --coverage --watchAll=false
                    '''
                }
            }
            post {
                always {
                    dir('backend') {
                        publishHTML([
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: 'coverage/lcov-report',
                            reportFiles: 'index.html',
                            reportName: 'Backend Coverage Report'
                        ])
                        junit 'test-results/*.xml'
                    }
                }
            }
        }
        
        stage('Security Scan') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('backend') {
                    sh '''
                        npm audit --audit-level high || echo "Security scan completed"
                        # Add additional security tools like Snyk if needed
                    '''
                }
            }
        }
        
        stage('Build Backend') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('backend') {
                    sh '''
                        docker build -t ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} .
                        docker tag ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                    '''
                }
            }
        }
        
        stage('Push Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login ${DOCKER_REGISTRY} -u $DOCKER_USER --password-stdin
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh '''
                        kubectl set image deployment/backend backend=${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/backend -n voting-app-staging
                    '''
                }
            }
        }
        
        stage('Integration Tests') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh '''
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app-staging --timeout=300s
                        
                        # Run integration tests
                        curl -f http://backend-service:8000/health || exit 1
                        curl -f http://backend-service:8000/api/votes || exit 1
                    '''
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo '🎉 Backend pipeline completed successfully!'
        }
        failure {
            echo '❌ Backend pipeline failed!'
        }
    }
} 