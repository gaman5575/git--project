import os
import requests
import sys

jenkins_user = os.getenv('JENKINS_USER')
jenkins_token = os.getenv('JENKINS_TOKEN')
jenkins_urls = [
    "http://192.168.1.45:8080/job/version-release-pipeline/build",
    # Add more URLs as needed
]

for url in jenkins_urls:
    result = requests.post(url, auth=(jenkins_user, jenkins_token))
    
    if result.status_code == 201:
        print(f"Jenkins Job at {url} executed successfully")
    else:
        print(f"Jenkins Job at {url} failed!! {result.status_code}")
        sys.exit(1)