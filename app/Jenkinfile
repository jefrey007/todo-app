pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/yourimage:latest"
        AWS_EC2_IP = "your-ec2-public-ip"
        SSH_KEY_PATH = "/path/to/your/ssh/key"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/yourrepo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        docker.push(DOCKER_IMAGE)
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sshagent(credentials: ['ec2-ssh-credentials']) {
                        sh "ssh -i $SSH_KEY_PATH ubuntu@$AWS_EC2_IP 'docker pull $DOCKER_IMAGE && docker run -d $DOCKER_IMAGE'"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
