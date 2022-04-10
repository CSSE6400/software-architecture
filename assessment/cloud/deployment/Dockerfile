FROM ubuntu:18.04

# Install terraform
RUN apt-get update \
    && apt-get install -y unzip wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip \
    && unzip terraform_1.1.0_linux_amd64.zip -d /usr/local/bin \
    && rm -rf terraform_1.1.0_linux_amd64.zip \
    && chmod +x /usr/local/bin/terraform

# Install docker client
RUN apt-get update \
    && apt-get install -y docker.io \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
CMD ["bash", "/workspace/deploy.sh"]
