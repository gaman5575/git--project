import os
import requests
import sys

jenkins_user = os.getenv('JENKINS_USER')
jenkins_token = os.getenv('JENKINS_TOKEN')
jenkins_urls = [
    #"http://192.168.125.147:8080/job/python-project-1/build",
    #"http://192.168.125.147:8080/job/python-project-2/build",
    #"http://192.168.125.147:8080/job/python-project-3/build",
    #"http://192.168.125.147:8080/job/python-project-4/build",
    "http://192.168.125.147:8080/job/python-project-5/build"
    
    
]

for url in jenkins_urls:
    result = requests.post(url, auth=(jenkins_user, jenkins_token))
    
    if result.status_code == 201:
        print(f"Jenkins Job at {url} executed successfully")
    else:
        print(f"Jenkins Job at {url} failed!! {result.status_code}")
        sys.exit(1)
