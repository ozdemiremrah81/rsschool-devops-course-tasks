pipeline {
    agent any

    environment {
        // Define reusable variables
        DOCKER_REGISTRY = '222634386594.dkr.ecr.eu-north-1.amazonaws.com'
        APP_NAME = 'mern-app'
        CLIENT_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-client"
        SERVER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-server"
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

        stage('Build Docker Images') {
            steps {
                echo 'Building Docker images...'
                sh '''
                docker build -t ${CLIENT_IMAGE}:latest ./client
                docker build -t ${SERVER_IMAGE}:latest ./server
                '''
            }
        }

        stage('Push Docker Images to ECR') {
            steps {
                echo 'Pushing Docker images to ECR...'
                withCredentials([aws(credentialsId: 'aws-ecr-credentials', region: 'eu-north-1')]) {
                    sh '''
                    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${DOCKER_REGISTRY}
                    docker push ${CLIENT_IMAGE}:latest
                    docker push ${SERVER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes with Helm') {
            steps {
                echo 'Deploying application to Kubernetes with Helm...'
                withCredentials([file(credentialsId: 'kubeconfig-file', variable: 'KUBECONFIG')]) {
                    sh '''
                    helm upgrade --install ${HELM_RELEASE_NAME} ${HELM_CHART_PATH} \
                      --set client.image.repository=${CLIENT_IMAGE} \
                      --set client.image.tag=latest \
                      --set server.image.repository=${SERVER_IMAGE} \
                      --set server.image.tag=latest \
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
                curl -f http://<your-k3s-ec2-public-ip>:<your-app-port> || exit 1
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
