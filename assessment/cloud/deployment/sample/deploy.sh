#!/bin/bash

docker run hello-world

terraform init
terraform apply -auto-approve
