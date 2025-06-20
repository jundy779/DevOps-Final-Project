pipeline {
    agent any
    
    options {
        cleanBeforeCheckout()
        skipDefaultCheckout()
    }
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        KUBECONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    // Force clean workspace
                    sh '''
                        echo "🧹 Cleaning workspace..."
                        rm -rf * || true
                        rm -rf .* || true
                        echo "✅ Workspace cleaned"
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                script {
                    // Clean checkout with retry
                    retry(3) {
                        checkout scm
                    }
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
                        echo "📦 Installing dependencies..."
                        npm install
                        echo "🧪 Running tests..."
                        npm test
                        echo "🐳 Building Docker image..."
                        docker build -t ${DOCKER_REGISTRY}/voting-app-backend:${IMAGE_TAG} .
                        docker tag ${DOCKER_REGISTRY}/voting-app-backend:${IMAGE_TAG} ${DOCKER_REGISTRY}/voting-app-backend:latest
                    '''
                }
            }
            post {
                success {
                    echo '✅ Backend build successful'
                }
                failure {
                    echo '❌ Backend build failed'
                    currentBuild.result = 'FAILURE'
                }
            }
        }
        
        stage('Push Images') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                }
            }
            steps {
                script {
                    sh '''
                        echo "📤 Pushing Docker images..."
                        docker push ${DOCKER_REGISTRY}/voting-app-backend:${IMAGE_TAG}
                        docker push ${DOCKER_REGISTRY}/voting-app-backend:latest
                    '''
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                }
            }
            steps {
                script {
                    sh '''
                        echo "☸️ Deploying to Kubernetes..."
                        # Update image tags in Kubernetes manifests
                        sed -i "s|voting-app-backend:latest|${DOCKER_REGISTRY}/voting-app-backend:${IMAGE_TAG}|g" kubernetes/backend-deployment.yaml
                        
                        # Deploy to Kubernetes
                        kubectl apply -f kubernetes/namespace.yaml
                        kubectl apply -f kubernetes/secret.yaml
                        kubectl apply -f kubernetes/postgres-deployment.yaml
                        
                        # Wait for database to be ready
                        kubectl wait --for=condition=ready pod -l app=postgres -n voting-app --timeout=300s
                        
                        # Deploy backend
                        kubectl apply -f kubernetes/backend-deployment.yaml
                        
                        # Wait for backend to be ready
                        kubectl wait --for=condition=ready pod -l app=backend -n voting-app --timeout=300s
                    '''
                }
            }
        }
        
        stage('Integration Test') {
            when {
                allOf {
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                }
            }
            steps {
                script {
                    sh '''
                        echo "🧪 Running integration tests..."
                        # Wait for services to be ready
                        sleep 30
                        
                        # Test backend API
                        BACKEND_IP=$(kubectl get service backend-service -n voting-app -o jsonpath='{.spec.clusterIP}')
                        kubectl run test-pod --image=curlimages/curl -n voting-app --rm -i --restart=Never -- curl -f http://$BACKEND_IP:8000/health || exit 1
                        echo "✅ Backend health check passed"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup
            sh '''
                echo "🧹 Cleaning up..."
                kubectl delete pod test-pod -n voting-app --ignore-not-found=true
            '''
            
            // Notify results
            script {
                if (currentBuild.result == 'SUCCESS') {
                    echo '🎉 Backend deployment successful!'
                } else {
                    echo '❌ Backend deployment failed!'
                }
            }
        }
        success {
            echo '✅ Backend pipeline completed successfully'
        }
        failure {
            echo '❌ Backend pipeline failed'
        }
    }
} 