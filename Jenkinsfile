pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    DOCKERHUB_USERNAME = 'faizalfandimulyadi'
    BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/voting-backend"
    FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/voting-frontend"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'docker build -t $BACKEND_IMAGE:latest .'
        }
      }
    }

    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh 'docker build -t $FRONTEND_IMAGE:latest .'
        }
      }
    }

    stage('Docker Login') {
      steps {
        sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_USERNAME --password-stdin"
      }
    }

    stage('Push Images') {
      steps {
        sh 'docker push $BACKEND_IMAGE:latest'
        sh 'docker push $FRONTEND_IMAGE:latest'
      }
    }
  }
}
