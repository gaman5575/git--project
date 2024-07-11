#!/bin/bash

# Set the repositories to clone and update
repos=("repos1" "repos2" "repos3"  "repos4" "repos5" )  # add your repository names here

# Docker username
docker_username=gaman5575

# Get the branch name from the first argument
new_branch=$1

# Clone each repository
for repo in "${repos[@]}"; do
  git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/${GIT_USERNAME}/${repo}.git"
  cd "${repo}" || { echo "Failed to enter repo directory"; exit 1; }

  # Configure git user
  git config user.email "${GIT_USERNAME}@gmail.com"
  git config user.name "${GIT_USERNAME}"

  
  # Get the current version number
  current_version=$(grep -oP '(?<=version: )\K[\d\.]+' version.yml)
  
  # Increment the version number
  if [ $(echo "$current_version" | awk -F. '{print $2}') -eq 9 ]; then
    new_major_version=$(echo "$current_version" | awk -F. '{print $1 + 1}')
    new_minor_version=0
  else
    new_major_version=$(echo "$current_version" | awk -F. '{print $1}')
    new_minor_version=$(echo "$current_version" | awk -F. '{print $2 + 1}')
  fi
  
  new_version="${new_major_version}.${new_minor_version}"
  
  # Create a new branch with the entered name
  git checkout -b "${new_branch}"
  
  # Update the version in version.yml
  sed -i "s/version: .*/version: ${new_version}/" version.yml
  
  # Create a Dockerfile if it doesn't exist
  if [ ! -f Dockerfile ]; then
    echo "FROM python:3.9-slim" > Dockerfile
    echo "WORKDIR /app" >> Dockerfile
    echo "LABEL version=\"${new_version}\"" >> Dockerfile
    echo "COPY . /app" >> Dockerfile
    echo "CMD [\"python\", \"app.py\"]" >> Dockerfile
  else
    # Update the version label in the Dockerfile
    sed -i "s/LABEL version=\".*\"/LABEL version=\"${new_version}\"/" Dockerfile
  fi

  # Add and commit the changes
  git add .
  git commit -m "Updated version to ${new_version}"
  
  # Push the changes to the remote repository with authentication
  git push "https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/${GIT_USERNAME}/${repo}.git" "${new_branch}"


  # Docker login
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
  
  # Build the Docker image
  docker build -t "${docker_username}/${repo}:${new_version}" .
  
  # Push the Docker image to Docker Hub
  docker push "${docker_username}/${repo}:${new_version}"

  cd ..
  rm -rf "${repo}"

done
