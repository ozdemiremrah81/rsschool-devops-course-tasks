pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = '222634386594.dkr.ecr.eu-north-1.amazonaws.com'
        APP_NAME = 'mern-app'
        CLIENT_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-client"
        SERVER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-server"
        MONGO_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-mongo"
        HELM_CHART_PATH = 'helm/' // Adjust if your Helm chart is in a different folder
        K8S_NAMESPACE = 'default'
        HELM_RELEASE_NAME = 'mern-stack'
        DOCKER_COMPOSE_VERSION = '2.2.3' // Adjust the version if needed
    }

    stages {
        stage('Install Docker Compose') {
            steps {
                echo 'Installing Docker Compose...'
                sh '''
                curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose
                docker-compose --version
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub repository...'