#!/bin/bash

# structurizr

docker run -it --rm -p 8080:8080 -v $(pwd):/usr/local/structurizr structurizr/lite

# GitLab

export GITLAB_HOME=$(pwd)/gitlab
docker run -it --rm -p 223:80 --shm-size 256m -v ${GITLAB_HOME}/config:/etc/gitlab -v ${GITLAB_HOME}/logs:/var/logs/gitlab -v ${GITLAB_HOME}/data:/var/opt/gitlab gitlab/gitlab-ee:latest

# Doom

docker run -it --rm -p 224:6901 -e VNC_PW=password kasmweb/doom:1.12.0
# user: kasm_user

