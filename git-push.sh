#!/bin/bash

source ./credentials.txt

# Set the repositories to clone and update
repos=("repos1" "repos2" "repos3" "repos4" "repos5")  # add your repository names here


# branch name
new_branch=branch-1

#  the Docker Hub username
docker_username=gaman5575

# Clone each repository
for repo in "${repos[@]}"; do
  git clone "https://${username}:${token}@github.com/${username}/${repo}.git"
  cd "${repo}" || { echo "Failed to enter repo directory"; exit 1; }
  
  
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
  git push "https://${username}:${token}@github.com/${username}/${repo}.git" "${new_branch}"

  # Build the Docker image
  docker build -t "${docker_username}/${repo}:${new_version}" .
  
  # Push the Docker image to Docker Hub
  docker push "${docker_username}/${repo}:${new_version}"

  cd ..
  rm -rf "${repo}"

done

