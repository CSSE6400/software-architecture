#!/bin/bash

docker run -i --rm --name terraform -v "$PWD":/usr/src/app -w /usr/src/app -t hashicorp/terraform:latest ${@}
