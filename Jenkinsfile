pipeline{
    agent {
        label 'git_project_node'
    }
    stages {
        stage('Git Checkout') {
            steps{
                // Git Cloning Of Repos
                git branch: 'main',
                    url: 'https://github.com/gaman5575/git-project.git'
            }
        }
        stage(' Run Scripts') {
            steps {
                // Runnig The Shell Script
                sh 'sh git-push.sh'
            }
        }
    }

    post {
        success{
            // Notify Success
            echo 'The Script Executed Successfully!!!'
        }
        failure{
            //Notify Failure
            echo 'The Script Execution Failed!!!'
        }
    }

    
} 