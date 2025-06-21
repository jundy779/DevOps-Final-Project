<<<<<<< HEAD
 pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        FRONTEND_IMAGE = 'voting-app-frontend'
        BACKEND_IMAGE = 'voting-app-backend'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Parallel Build & Test') {
            parallel {
                stage('Frontend Pipeline') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    stages {
                        stage('Frontend Dependencies') {
                            steps {
                                dir('frontend') {
                                    sh '''
                                        npm install
                                        npm audit --audit-level moderate || echo "Security audit completed"
                                    '''
                                }
                            }
                        }
                        
                        stage('Frontend Tests') {
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
                        
                        stage('Frontend Build') {
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
                    }
                }
                
                stage('Backend Pipeline') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    stages {
                        stage('Backend Dependencies') {
                            steps {
                                dir('backend') {
                                    sh '''
                                        npm install
                                        npm audit --audit-level moderate || echo "Security audit completed"
                                    '''
                                }
                            }
                        }
                        
                        stage('Backend Tests') {
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
                        
                        stage('Backend Build') {
                            steps {
                                dir('backend') {
                                    sh '''
                                        docker build -t ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} .
                                        docker tag ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                                    '''
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Push Images') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login ${DOCKER_REGISTRY} -u $DOCKER_USER --password-stdin
                            
                            # Push Frontend Image
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
                            
                            # Push Backend Image
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'develop'
                }
            }
            steps {
                script {
                    sh '''
                        # Deploy Backend first
                        kubectl set image deployment/backend backend=${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/backend -n voting-app-staging
                        
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app-staging --timeout=300s
                        
                        # Deploy Frontend
                        kubectl set image deployment/frontend frontend=${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/frontend -n voting-app-staging
                    '''
                }
            }
        }
        
        stage('Integration Tests') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'develop'
                }
            }
            steps {
                script {
                    sh '''
                        # Wait for all services to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app-staging --timeout=300s
                        kubectl wait --for=condition=ready pod -l app=frontend -n voting-app-staging --timeout=300s
                        
                        # Test Backend API
                        kubectl run test-backend --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/health
                        
                        # Test Frontend
                        kubectl run test-frontend --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://frontend-service:80
                        
                        # Test API Integration
                        kubectl run test-api --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/api/votes
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    sh '''
                        # Deploy Backend to production
                        kubectl set image deployment/backend backend=${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} -n voting-app
                        kubectl rollout status deployment/backend -n voting-app
                        
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
                        
                        # Deploy Frontend to production
                        kubectl set image deployment/frontend frontend=${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} -n voting-app
                        kubectl rollout status deployment/frontend -n voting-app
                    '''
                }
            }
        }
        
        stage('Production Health Check') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    sh '''
                        # Wait for all services to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
                        kubectl wait --for=condition=ready pod -l app=frontend -n voting-app --timeout=300s
                        
                        # Production health checks
                        kubectl run health-check --image=curlimages/curl -n voting-app --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/health
                        
                        kubectl run frontend-check --image=curlimages/curl -n voting-app --rm -i --restart=Never -- \
                            curl -f http://frontend-service:80
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
            echo '🎉 Multi-job pipeline completed successfully!'
            script {
                if (env.BRANCH_NAME == 'main') {
                    echo '🚀 Application deployed to production!'
                } else if (env.BRANCH_NAME == 'develop') {
                    echo '🧪 Application deployed to staging!'
                }
            }
        }
        failure {
            echo '❌ Multi-job pipeline failed!'
        }
        cleanup {
            sh '''
                # Cleanup test pods
                kubectl delete pod test-backend -n voting-app-staging --ignore-not-found=true
                kubectl delete pod test-frontend -n voting-app-staging --ignore-not-found=true
                kubectl delete pod test-api -n voting-app-staging --ignore-not-found=true
                kubectl delete pod health-check -n voting-app --ignore-not-found=true
                kubectl delete pod frontend-check -n voting-app --ignore-not-found=true
            '''
        }
    }
=======
 pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        FRONTEND_IMAGE = 'voting-app-frontend'
        BACKEND_IMAGE = 'voting-app-backend'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Parallel Build & Test') {
            parallel {
                stage('Frontend Pipeline') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    stages {
                        stage('Frontend Dependencies') {
                            steps {
                                dir('frontend') {
                                    sh '''
                                        npm install
                                        npm audit --audit-level moderate || echo "Security audit completed"
                                    '''
                                }
                            }
                        }
                        
                        stage('Frontend Tests') {
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
                        
                        stage('Frontend Build') {
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
                    }
                }
                
                stage('Backend Pipeline') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    stages {
                        stage('Backend Dependencies') {
                            steps {
                                dir('backend') {
                                    sh '''
                                        npm install
                                        npm audit --audit-level moderate || echo "Security audit completed"
                                    '''
                                }
                            }
                        }
                        
                        stage('Backend Tests') {
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
                        
                        stage('Backend Build') {
                            steps {
                                dir('backend') {
                                    sh '''
                                        docker build -t ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} .
                                        docker tag ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                                    '''
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Push Images') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login ${DOCKER_REGISTRY} -u $DOCKER_USER --password-stdin
                            
                            # Push Frontend Image
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
                            
                            # Push Backend Image
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'develop'
                }
            }
            steps {
                script {
                    sh '''
                        # Deploy Backend first
                        kubectl set image deployment/backend backend=${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/backend -n voting-app-staging
                        
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app-staging --timeout=300s
                        
                        # Deploy Frontend
                        kubectl set image deployment/frontend frontend=${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} -n voting-app-staging
                        kubectl rollout status deployment/frontend -n voting-app-staging
                    '''
                }
            }
        }
        
        stage('Integration Tests') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'develop'
                }
            }
            steps {
                script {
                    sh '''
                        # Wait for all services to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app-staging --timeout=300s
                        kubectl wait --for=condition=ready pod -l app=frontend -n voting-app-staging --timeout=300s
                        
                        # Test Backend API
                        kubectl run test-backend --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/health
                        
                        # Test Frontend
                        kubectl run test-frontend --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://frontend-service:80
                        
                        # Test API Integration
                        kubectl run test-api --image=curlimages/curl -n voting-app-staging --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/api/votes
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    sh '''
                        # Deploy Backend to production
                        kubectl set image deployment/backend backend=${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} -n voting-app
                        kubectl rollout status deployment/backend -n voting-app
                        
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
                        
                        # Deploy Frontend to production
                        kubectl set image deployment/frontend frontend=${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} -n voting-app
                        kubectl rollout status deployment/frontend -n voting-app
                    '''
                }
            }
        }
        
        stage('Production Health Check') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                    branch 'main'
                }
            }
            steps {
                script {
                    sh '''
                        # Wait for all services to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
                        kubectl wait --for=condition=ready pod -l app=frontend -n voting-app --timeout=300s
                        
                        # Production health checks
                        kubectl run health-check --image=curlimages/curl -n voting-app --rm -i --restart=Never -- \
                            curl -f http://backend-service:8000/health
                        
                        kubectl run frontend-check --image=curlimages/curl -n voting-app --rm -i --restart=Never -- \
                            curl -f http://frontend-service:80
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
            echo '🎉 Multi-job pipeline completed successfully!'
            script {
                if (env.BRANCH_NAME == 'main') {
                    echo '🚀 Application deployed to production!'
                } else if (env.BRANCH_NAME == 'develop') {
                    echo '🧪 Application deployed to staging!'
                }
            }
        }
        failure {
            echo '❌ Multi-job pipeline failed!'
        }
        cleanup {
            sh '''
                # Cleanup test pods
                kubectl delete pod test-backend -n voting-app-staging --ignore-not-found=true
                kubectl delete pod test-frontend -n voting-app-staging --ignore-not-found=true
                kubectl delete pod test-api -n voting-app-staging --ignore-not-found=true
                kubectl delete pod health-check -n voting-app --ignore-not-found=true
                kubectl delete pod frontend-check -n voting-app --ignore-not-found=true
            '''
        }
    }
>>>>>>> 5eec687 (Add Jenkinsfile for CI/CD)
}