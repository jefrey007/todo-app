pipeline {
    agent any

    environment {
        // DockerHub credentials ID in Jenkins
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials'
        // DockerHub repository name
        DOCKER_HUB_REPO = 'your-dockerhub-username/todo-app'
        // Docker image tag (can use Git commit hash, branch, or build number)
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        // EC2 SSH credentials ID in Jenkins
        EC2_CREDENTIALS = 'ec2-ssh-credentials'
        // Target EC2 instance IP address
        EC2_IP = 'your-ec2-instance-ip'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', url: 'https://github.com/jefrey007/todo-app.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the Docker image...'
                sh """
                docker build -t ${DOCKER_HUB_REPO}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push') {
            steps {
                echo 'Pushing the Docker image to Docker Hub...'
                withDockerRegistry([credentialsId: DOCKER_HUB_CREDENTIALS, url: '']) {
                    sh """
                    docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the Docker container on the EC2 instance...'
                sshagent(credentials: [EC2_CREDENTIALS]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} << EOF
                    docker pull ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                    docker stop todo-app || true
                    docker rm todo-app || true
                    docker run -d --name todo-app -p 80:80 ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                    EOF
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker images from Jenkins agent...'
            sh """
            docker rmi ${DOCKER_HUB_REPO}:${IMAGE_TAG} || true
            """
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
