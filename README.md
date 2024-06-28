# Repository Setup and Script Execution Instructions

Prerequisites
1. Git: Ensure you have Git installed on your machine.
2. Docker: Please make sure you have Docker installed and running.
3. GitHub Token: Generate a personal access token on GitHub.
4. Docker Hub Account: Have a Docker Hub account to push images.

## Dependencies and Requirements

Before running the script, ensure you have the following installed:

- Git
- Docker

Before running the script, ensure you have completed the following steps:

## Step 1: Generate GitHub Personal Access Token (PAT)

1. Go to [GitHub's Personal Access Tokens page](https://github.com/settings/tokens).
2. Click on "Generate new token".
3. Give your token a descriptive name.
4. Select the following scopes:
   - `repo`: Full control of private repositories.
5. Click "Generate token" and copy the token immediately.

## Step 2: Set up credentials.txt

Create a file named `credentials.txt` in the root of your script directory with the following content:


Replace `<your GitHub username>` and `<your GitHub Personal Access Token>` with your actual GitHub username and the token you generated in Step 1.

## Step 3: Update Script Parameters

1. Open the script (`git-push.sh`) and update the following parameters:
   - `repos`: Add the names of the repositories you want to clone and update.
   - `docker_username`: Enter your Docker Hub username.
   - Ensure the script paths and commands match your project structure and requirements.

## Step 4: Execute the Script

1. Open a terminal.
2. Navigate to the directory containing `git-push.sh`.
3. Run the script with the following command:
   ```bash
   ./script.sh



Script Overview
The script automates the following tasks for each repository specified in repos:
Clones the repository.
Creates a new branch with the specified name.
Updates the version number in version.yml.
Creates or updates a Dockerfile in the repository.
Commits changes and pushes them to the repository.
Builds Docker images and pushes them to Docker Hub with appropriate tags.


### Additional Notes:
- Please make sure you have Docker installed and configured and have permission to perform these actions on the specified repositories.
- Replace placeholders (`<your GitHub username>`, `<your GitHub Personal Access Token>`, etc.) with your actual information.
- Customize the instructions and script overview to fit your specific project requirements.
- Ensure the `README.md` file is placed in the root directory of your project alongside the `git-push.sh` and `credentials.txt` files.

