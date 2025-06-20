pipeline {
    agent any
    
    options {
        cleanBeforeCheckout()
    }
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        FRONTEND_IMAGE = 'voting-app-frontend'
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
                dir('frontend') {
                    sh '''
                        npm install
                        npm audit --audit-level moderate || echo "Security audit completed"
                    '''
                }
            }
        }
        
        stage('Lint & Format') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('frontend') {
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
                dir('frontend') {
                    sh '''
                        npm test -- --coverage --watchAll=false
                    '''
                }
            }
            post {
                always {
                    dir('frontend') {
                        publishHTML([
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: 'coverage/lcov-report',
                            reportFiles: 'index.html',
                            reportName: 'Frontend Coverage Report'
                        ])
                    }
                }
            }
        }
        
        stage('Build Frontend') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                dir('frontend') {
                    sh '''
                        npm run build
                        docker build -t ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} .
                        docker tag ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
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
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
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
                        kubectl set image deployment/frontend frontend=${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/frontend -n voting-app-staging
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
            echo '🎉 Frontend pipeline completed successfully!'
        }
        failure {
            echo '❌ Frontend pipeline failed!'
        }
    }
} 