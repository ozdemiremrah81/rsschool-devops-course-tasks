pipeline {
    agent {
        kubernetes {
            label 'emopod'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              name: emrahpod
              labels:
                pod-template: emrahpod
            spec:
              containers:
                - name: jnlp
                  image: jenkins/inbound-agent:latest
                  args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
                - name: docker
                  image: docker:20.10.8
                  command:
                    - cat
                  tty: true
                  volumeMounts:
                    - mountPath: /var/run/docker.sock
                      name: docker-sock
              volumes:
                - name: docker-sock
                  hostPath:
                    path: /var/run/docker.sock
            """
        }
    }

    environment {
        DOCKER_REGISTRY = '222634386594.dkr.ecr.eu-north-1.amazonaws.com'
        APP_NAME = 'mern-app'
        CLIENT_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-client"
        SERVER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-server"
        MONGO_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}-mongo"
        HELM_CHART_PATH = 'helm/' // Adjust if your Helm chart is in a different folder
        K8S_NAMESPACE = 'default'
        HELM_RELEASE_NAME = 'mern-stack'
        DOCKER_COMPOSE_PATH = '/tmp/docker-compose'
    }

    stages {
        stage('Install Docker Compose') {
            steps {
                echo 'Installing Docker Compose...'
                sh '''
                curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o ${DOCKER_COMPOSE_PATH}
                chmod +x ${DOCKER_COMPOSE_PATH}
                ${DOCKER_COMPOSE_PATH} --version
                '''
            }
        }

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
                ${DOCKER_COMPOSE_PATH} build
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
                withCredentials([aws(credentialsId: 'aws-ecr-credentials', region: 'eu-north-1')]) {
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
                withCredentials([file(credentialsId: 'kubeconfig-file', variable: 'KUBECONFIG')]) {
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
