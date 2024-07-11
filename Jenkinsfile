pipeline {
    agent any
    parameters {
        string(name: 'new_branch', description: 'Enter the new branch', defaultValue: 'main')
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
                    sh './git-push.sh ${params.new_branch}'
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
