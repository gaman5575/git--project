pipeline {
    agent {
        label 'git_project_node'
    }

    environment {
        GIT_USERNAME = 'gaman5575'
        GIT_TOKEN = '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'
        DOCKER_USERNAME = 'gaman5575'
    }

    stages {
        stage('Clone Repositories') {
            steps {
                script {
                    // Checkout the repository containing the git-push.sh script
                    git credentialsId: 'git-credentials', url: 'https://github.com/gaman5575/git-project.git'
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
// pipeline{
//     agent {
//         label 'git_project_node'
//     }
//     stages {
//         stage('Git Checkout') {
//             steps{
//                 // Git Cloning Of Repos
//                 git branch: 'main',
//                     url: 'https://github.com/gaman5575/git-project.git'
//             }
//         }
//         stage(' Run Scripts') {
//             steps {
//                 // Runnig The Shell Script
//                 sh 'sh git-push.sh'
//             }
//         }
//     }

//     post {
//         success{
//             // Notify Success
//             echo 'The Script Executed Successfully!!!'
//         }
//         failure{
//             //Notify Failure
//             echo 'The Script Execution Failed!!!'
//         }
//     }

    
// } 
