pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git url: 'https://github.com/jefrey007/todo-app.git', branch: 'main', credentialsId: 'github-pat'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the Docker image...'
                sh 'docker build -t your-dockerhub-username/todo-app:latest .'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing the Docker image to Docker Hub...'
                sh 'docker push your-dockerhub-username/todo-app:latest'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the containerized application...'
                sh 'ssh -o StrictHostKeyChecking=no ec2-user@<EC2_IP> "docker run -d -p 80:3000 your-dockerhub-username/todo-app:latest"'
            }
        }
    }
}
