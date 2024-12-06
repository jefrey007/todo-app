pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yourdockerhubusername/todo-app'
        DOCKER_TAG = 'latest'
        EC2_HOST = 'your-ec2-ip-or-dns'
        EC2_USER = 'ubuntu'  // Replace with the appropriate user for your EC2 instance
        SSH_KEY_PATH = '/path/to/your/ssh/key.pem'  // Path to your EC2 SSH private key
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub using the credentials stored in Jenkins
                git credentialsId: 'github-pat', url: 'https://github.com/jefrey007/todo-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Deploy the Docker image to your EC2 instance
                    // Assuming Docker is already installed on the EC2 instance
                    sh """
                        ssh -i $SSH_KEY_PATH $EC2_USER@$EC2_HOST << EOF
                        docker pull $DOCKER_IMAGE:$DOCKER_TAG
                        docker run -d -p 80:80 $DOCKER_IMAGE:$DOCKER_TAG
                        EOF
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up or perform any necessary post-build steps
            echo 'Pipeline execution completed'
        }

        success {
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
