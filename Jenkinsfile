pipeline {
    agent {
        label 'git_project_node'
    }
    parameters {
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'main',
            description: 'Enter the branch name to build'
        )
    }
    stages {
        stage('Git Checkout') {
            steps {
                // Git checkout
                git branch: "${params.BRANCH_NAME}",
                    url: 'https://github.com/gaman5575/git-project.git'
            }
        }
        stage('Run Script') {
            steps {
                // Bind Jenkins credentials for Git authentication
                withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                    sh 'chmod +x git-push.sh'
                    sh './git-push.sh "${params.BRANCH_NAME}"'
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
