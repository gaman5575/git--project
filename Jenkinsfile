pipeline {
    agent {
        label 'git_project_node'
    }
    stages{
        stage('Git Checkout'){
            steps{
                //Git chekout
                git branch: 'main',
                    url: 'https://github.com/gaman5575/git-project.git'
            }
        }
        stage('Run Script'){
            steps{
                sh 'chmod +x git-push.sh'
                sh './git-push.sh'
            }
        }
    }

    post{
        success{
            echo 'Script Runs Successfully!!!'
        }
        failure{
            echo 'Script Failed!!!'
        }
    }
}
