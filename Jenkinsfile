pipeline {
    agent any
    parameters {
        string(name: 'newBranch', description: 'Enter the new branch', defaultValue: 'main')
    }
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
                // Bind Jenkins credentials for Git authentication
                withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                    sh 'chmod +x git-push.sh'
                    sh 'bash ./git-push.sh "${params.newBranch}"'
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
