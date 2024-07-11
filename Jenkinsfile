pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                // Git checkout
                git branch: 'main',
                    url: 'https://github.com/gaman5575/git-project.git'
            }
        }
        stage('Run Script') {
            steps {
                // Bind Jenkins credentials for Git and Docker authentication
                withCredentials([
                    usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN'),
                    usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
                ]) {
                    sh 'chmod +x git-push.sh'
                    sh './git-push.sh branch'
                }
            }
        }
    }
    post {
        success {
            echo 'Script Runs Successfully!!!'
        }
        failure {
            echo 'Script Failed!!!'
        }
    }
}
