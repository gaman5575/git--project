pipeline {
    agent {
        label 'git_project_node'
    }

    environment {
        GIT_USERNAME = 'gaman5575'
        DOCKER_USERNAME = 'gaman5575'
    }

    stages {
        stage('Clone Repositories') {
            environment {
                GITHUB_TOKEN = credentials('GITHUB_TOKEN')
            }
            steps {
                script {
                    // Checkout the repository containing the git-push.sh script
                    git credentialsId: 'GITHUB_TOKEN', url: 'https://github.com/gaman5575/git-project.git'
                }
            }
        }

        stage('Run Script') {
            steps {
                script {
                    // Make the script executable
                    sh 'chmod +x git-push.sh'

                    // Run the script
                    sh './git-push.sh'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
