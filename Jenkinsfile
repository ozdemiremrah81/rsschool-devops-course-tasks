pipeline {
    agent any

    environment {
        // Define reusable variables
        DOCKER_REGISTRY = '222634386594.dkr.ecr.eu-north-1.amazonaws.com'
        APP_NAME = 'mern-app'
        CLIENT_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-client"
        SERVER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-server"
        MONGO_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-mongo"
        HELM_CHART_PATH = 'helm/' // Adjust if your Helm chart is in a different folder
        K8S_NAMESPACE = 'default'
        HELM_RELEASE_NAME = 'mern-stack'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Images with Docker Compose') {
            steps {
                echo 'Building Docker images with Docker Compose...'
                sh '''
                docker-compose build
                '''
            }
        }

        stage('Tag MongoDB Image') {
            steps {
                echo 'Tagging MongoDB image...'
                sh '''
                docker pull mongo:latest
                docker tag mongo:latest ${MONGO_IMAGE}:latest
                '''
            }
        }

        stage('Push Docker Images to ECR') {
            steps {
                echo 'Pushing Docker images to ECR...'
                withCredentials([aws(credentialsId: 'ecrcredentials', region: 'eu-north-1')]) {
                    sh '''
                    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${DOCKER_REGISTRY}
                    
                    # Push client image
                    docker tag mern-app_client:latest ${CLIENT_IMAGE}:latest
                    docker push ${CLIENT_IMAGE}:latest

                    # Push server image
                    docker tag mern-app_server:latest ${SERVER_IMAGE}:latest
                    docker push ${SERVER_IMAGE}:latest

                    # Push MongoDB image
                    docker push ${MONGO_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes with Helm') {
            steps {
                echo 'Deploying application to Kubernetes with Helm...'
                withCredentials([file(credentialsId: 'kubecredentials', variable: 'KUBECONFIG')]) {
                    sh '''
                    helm upgrade --install ${HELM_RELEASE_NAME} ${HELM_CHART_PATH} \
                      --set client.image.repository=${CLIENT_IMAGE} \
                      --set client.image.tag=latest \
                      --set server.image.repository=${SERVER_IMAGE} \
                      --set server.image.tag=latest \
                      --set mongo.image.repository=${MONGO_IMAGE} \
                      --set mongo.image.tag=latest \
                      --namespace ${K8S_NAMESPACE}
                    '''
                }
            }
        }

        stage('Smoke Test (Optional)') {
            steps {
                echo 'Running smoke test to verify application...'
                sh '''
                sleep 10 # Wait for pods to start
                curl -f http://http://13.60.11.219/:31177 || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
