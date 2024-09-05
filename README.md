Create a Release Pipeline For Python Projects Using Jenkins

The objective of the blog:
Release Python projects once a month by creating an automated CI/CD pipeline.
Summary of solution: 
To release Python projects automatically, we have taken two approaches. In the First Approach, using Bash script cloning reach repo and updating extracting version from 'version.yml' and increment them. At the end update the Docker image and push to the Docker Hub. I am running a Bash script using Jenkins.
The Second Approach creates a Jenkins pipeline for every repo and each pipeline clones its repo, version updating, Docker image building, and pushing. Also Creating a Centralized Jenkins Pipeline, clones a central repository, runs Python script, and triggers individual Jenkins jobs for each repository. 

Let us understand each app in detail.
Approach-1: Releasing Python projects using shell script, and Jenkins
Tools: Jenkins, Shell Script, Github, Docker
Objective: To Create an automated pipeline to release Python-based microservices, where we are updating the Docker image of each Python project, and pushing these images to the Docker hub. This whole process is managed by Bash script and Jenkins Pipeline to ensure consistent and repeatable operation.
Core work is done by bash script shown below:
#!/bin/bash

#1. # Set the repositories to clone and update
repos=("python-project-1" "python-project-2" "python-project-3"  "python-project-4" "python-project-5" )  # add your repository names here

#2. # Clone each repository
for repo in "${repos[@]}"; do
  git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/${GIT_USERNAME}/${repo}.git"
  cd "${repo}" || { echo "Failed to enter repo directory"; exit 1; }

  #3. # Configure git user
  git config user.email "${GIT_USERNAME}@gmail.com"
  git config user.name "${GIT_USERNAME}"

  #4. # Get the current version number
  current_version=$(grep -oP '(?<=version: )\K[\d\.]+' version.yml)

  new_major_version=\$(echo "\$current_version" | awk -F. '{print \$1 + 1}')
  new_version="\${new_major_version}.0.0"
  new_branch="${new_version}-release"

  #5. # Create a new branch with the entered name
  git checkout -b "${new_branch}"

  #6. # Update the version in version.yml
  sed -i "s/version: .*/version: ${new_version}/" version.yml

  #7. # Add and commit the changes
  git add .
  git commit -m "Updated version to ${new_version}"

  #7. # Push the changes to the remote repository with authentication
  git push "https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/${GIT_USERNAME}/${repo}.git" "${new_branch}"

  #8. # Docker login
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

  # Build the Docker image
  docker build -t "${docker_username}/${repo}:${new_version}" .

  #9. # Push the Docker image to Docker Hub
  docker push "${docker_username}/${repo}:${new_version}"

   #10. 
  cd ..
  rm -rf "${repo}"

done

Details of Bash script:
The first step is to create a variable for a list of Python-projects repositories.
We are cloning each repository.
We are configuring Git user credentials.
Extract the current version and then increment them.
Check out the new branch and then update the version.yml file.
Commits and pushes changes to the new branch on GitHub.
Each Repo has its Dockerfile.
Logs in Docker, build the image as the tag of the new version.
Pushes the docker image to dockerhub.
Cleans up the local python-project directory.

Generation Of Git Token:-
Open Your Git Profile On the Left side.

2. Open Settings.
3. In Settings, Go to 'Developer Settings' at the bottom.
4. Click on Personal Access Token and Choose 'Token classic'.
5. After That, Click 'Generate New Token', and Choose 'Generate New Token (Classic).
6. After that, give a Note of the Token, Choose the token's expiration then select Scopes of the repo.
7. In the Last Go to the Bottom, and Click on Generate Token.
8. Copy The Git Token on Notepad for reuse.
Jenkins Pipeline:
pipeline {
    agent any
    stages {
        stage('Git Checkout') {      //1.
            steps {
                // Git checkout
                git branch: 'main',
                    url: 'https://github.com/gaman5575/git-project.git'
            }
        }
        stage('Run Script') {
            steps {                   //2.
                // Bind Jenkins credentials for Git and Docker authentication
                withCredentials([
                    usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN'),
                    usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')  
                ]) {                  //3.
                    sh 'chmod +x git-push.sh'
                    sh './git-push.sh'   
                }
            }
        }
    }
    post {                    //4.
        success {
            echo 'Script Runs Successfully!!!'
        }
        failure {
            echo 'Script Failed!!!'
        }
    }
}
Let's Understand Jenkins Pipeline:-
Check out the repository's main branch containing the 'release-version.sh' script.
Loads Git and Docker credentials using Jenkins credentials binding.
Execute the 'release-version.sh' script.
Post-stage for success and failure message.

Installing Docker Plugins on Jenkins:-
In Jenkins Dashboard, Click on 'Manage Jenkins'.

2. In Manage Jenkins, 'System Configuration' section, Click on 'Plugins'.
3. In Plugins, Click on Available Plugins. Search For 'Docker Pipeline' and 'Docker Plugins'. And Install them.

Installing  Docker on Jenkins Machine and configuring:-
Firstly we have to install Docker on Jenkins machine.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

 sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
2. Now Add a Jenkins user in the Docker group, it can get access to Docker permissions.
sudo usermod -aG docker jenkins
sudo apt cat /etc/group | grep -i docker
3. At the End, Restart Docker and Jenkins.
sudo systemctl restart docker
sudo systemctl restart jenkins
Add Credentials on Jenkins:-
Go to Jenkins Dashboard and click on Manage Jenkins.

2. In Manage Jenkins, Go to the Security Section and Click on Credentials.
3. In Credentials, Click on System, and at the system click "Global Credentials (unrestricted)".
4. In Global, Click on 'Add Credentials'.
5. In Add Credentials, Kind Sections, you have to choose which type of credentials you want to give. For Us, we have to choose 'username and password'. You have to give your git username instead of password your git token, which you copied, and give your ID to call these credentials in the pipeline.
6. Use the same steps for Adding Docker Credentials.

Errors:-
There are a few errors that come with running the script.
The Shell script handles both Git repositories and Docker operations, making it more complex and hard to maintain.
Jenkinsfile runs script it will run the script in one pipeline, so a failure in any part of the script can halt the entire process without debugging errors.
Jenkins credentials for Docker and GitHub should be properly assigned but, what if we have different repos with different admins, so it will be difficult to create credentials for every repository? Its time taking and repos must have errors so it will fail if any error comes in any repos. Also, credentials are passed as environmental variables, which can be insecure if mishandled.
The Script is tightly coupled with the Jenkinsfile, making it more modular and harder to test individually.
Scaling this script to handle more repositories or complex workflows can be challenging.
Also, docker should be logged in with different users every time, for different repos.

To get over all errors I'm coming up with another approach.

Apporach-2: Releasing Python projects with Python script, Central Jenkinsfile, and individual Repository Jenkins Pipeline.

Overview: This project  automates the version management process and Docker image building and publishing Docker images to dockerhub. Using Jenkins continuous integration and deployment (CI/CD), the pipeline ensures that release updates are systematically applied, committed, and pushed to GitHub, followed by Docker image creation and publication to Docker hub.
Tools:  Python Script, Shell Script, Github, Docker, Jenkins
Approach Details:
Central Jenkinsfile:

pipeline {
    agent any

    environment {
        // Fetch credentials stored in Jenkins with the ID 'jenkins_credentials'
        JENKINS_CREDENTIALS = credentials('jenkins_credentials')
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Replace git url with your repo
                git url: 'https://github.com/gaman5575/python-release.git', branch: 'main'
            }
        }

        stage('Run Python Script') {
            steps {
                // Set environment variables for the Python script and run it
                withEnv(["JENKINS_USER=${JENKINS_CREDENTIALS_USR}", "JENKINS_TOKEN=${JENKINS_CREDENTIALS_PSW}"]) {
                    sh 'python3 jenkins-trigger.py'    //Run Python Script
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
Understanding Central Jenkins Pipeline:-
Clone a Central Repository: The pipeline starts with cloning the central repository where the version release script is stored.
Run Python Script: The Pipeline runs a Python script that triggers individual jobs for multiple projects.
Environment variable: Credentials for Github and Docker are securely passed as environment variables.

For Generating and Using Jenkins API:-
Firstly Go to Your Profile Section on the Top Right Side.

Then Click on Configure.

In Configure, please scroll down to API Token generate a token, and copy it. So you can reuse it for Jenkins Jobs.

2. Python script for triggering Jenkins jobs:
import os
import requests
import sys

jenkins_user = os.getenv('JENKINS_USER')
jenkins_token = os.getenv('JENKINS_TOKEN')
jenkins_urls = [
       "http://(Ip of jenkins machine):(port)/job/(pipeline name)/build",
    # Add more url 
]

for url in jenkins_urls:
    result = requests.post(url, auth=(jenkins_user, jenkins_token))
    
    if result.status_code == 201:
        print(f"Jenkins Job at {url} executed successfully")
    else:
        print(f"Jenkins Job at {url} failed!! {result.status_code}")
        sys.exit(1)
Understanding Python Script:-
Trigger Jenkins jobs: This script triggers various repositories using Jenkins API.
Authentication: Uses Jenkins credentials stored in an environment variable for authentication.

 3. Individuals Repository Jenkins Pipelines: 
pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                // Checkout your source code repository
                git branch: 'main',
                    url: 'https://github.com/gaman5575/(Your repository).git'
            }
        }

        stage('Clone Repositories and Update Version.yaml') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_CREDENTIALS_USR', passwordVariable: 'GIT_CREDENTIALS_PSW'),
                                 usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        def new_version = ""
                        sh """
                            echo "Cloning the repository"

                            git clone https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/${GIT_CREDENTIALS_USR}/(Your repository).git
                            cd (Your repository)

                            echo "Configuring Git"

                            git config user.email '${GIT_CREDENTIALS_USR}@gmail.com'
                            git config user.name '${GIT_CREDENTIALS_USR}'

                            echo "Finding Version in version.yml and Updating"

                            current_version=\$(grep -oP '(?<=version: )\\K[\\d\\.]+' version.yml)
                            new_major_version=\$(echo "\$current_version" | awk -F. '{print \$1 + 1}')
                            new_version="\${new_major_version}.0.0"
                            new_branch="\${new_version}-release"

                            echo "Git checkout to new branch"

                            git checkout -b "\${new_branch}"
                            git branch

                            echo "Adding new version to version.yml"

                            sed -i "s/version: .*/version: \${new_version}/" version.yml
                            cat version.yml

                            echo "Add and commit in git "
                            git add .
                            git commit -m "Changed version to \${new_version}"

                            echo "Pushing to git repository"
                            git push -u https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/${GIT_CREDENTIALS_USR}/(Your repository).git "\${new_branch}"

                            echo "Building the Docker image"
                            docker build -t "${DOCKER_USERNAME}/(Your repository):\${new_version}" .
                           
                            echo "Pushing the Docker image to Docker Hub"
                            docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
                            docker push "${DOCKER_USERNAME}/(Your repository):\${new_version}"

                            cd ..
                            rm -rf (Your repository)
                        """
                    }
                }
            }
        }
    }
}

Details of Jenkins Individuals pipelines:-
- Git Checkout: Each Repository has its own Jenkins Pipeline that checks out the code from the main branch.
 - Clone Repositories and Update Version: 
Clone Repositories and Update Version: Clone the repositories to the Jenkins repositories.
Configure the git user: Configure the git user with user credentials.
Update version: Read the current version from 'version.yml', increment it, and create a new branch for release.
Commit and Push changes: Commits the updated version file and pushes the changes to the new branch on GitHub.

 - Docker Image Build and Push:
Build Docker Image: Build a Docker image of each repository with the new version
Push Docker Image: Push the Docker image of each repository of each new version.

Let's create Jenkins Pipeline Jobs:-
Open the Jenkins dashboard using the machine's IP with port 8080. In my case, http://192.168.125.147:8080.
Build a Central Pipeline for executing multiple Jenkins jobs. 

In Jenkins Dashboard on the left 'New Items' click on that.

Give the name of the pipeline. And choose Pipeline and click on 'ok'.

In general, go to Build Triggers. In Build Triggers, click Trigger builds remotely (e.g., from scripts), and paste your Jenkins API.

Go to the Pipeline section, In Definition, Choose 'Pipeline Script with SCM ' and choose in SCM, Git as Source Code Management (SCM).

Give the URL of the git repo, and the branch name of your repo.

In Script Path, Give the Jenkins Pipeline file name. In my case it's Jenkinsfile, and in general its name is always this name but you can change it if you want. Click on save.

5.  Now create pipeline jobs for other repositories as the above steps, but take the pipeline name as your repository for easy understanding if the error comes out.
6. Go to the central job pipeline where the Python script is stored, then click Build Now. It will start all the jobs one by one.
Overcome Previous errors:
Centralized Control: The new approach uses a central Jenkins pipeline to trigger builds, ensuring each repository pipeline runs in a controlled environment.
Credentials Management: Credentials are securely managed using Jenkins credentials binding.
Automated Versioning: The new approach systematically increments the version number and ensures the correct version sequence.
Error handling: Improved error handling in Python script and Jenkins pipeline ensures better feedback and robustness.

Differences Between Both Approaches:

Commands for Scripting:
echo = "Display line of text on terminal."
cd = "Change directory. Uses for changing directory."
grep = "Used for searching and matching text patterns in files contained in the regular expressions"
awk = "Allows the user to use the numeric functions, variables, logical operators, and string functions."
sed = "A stream editor, can be used to edit text files, with its most common use being to replace occurrences of words in a file."
rm = "Permanent remove of any file or directory."

References:-
For Jenkins Pipeline:- Pipeline (jenkins.io)
Bash Scripting:- https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html
Python:- https://realpython.com/tutorials/devops/
