FROM golang

# RUN mkdir -p /workdir/terraform && \
#     git clone --depth 1 --branch v0.12.31 https://github.com/hashicorp/terraform.git && \
#     cd terraform && \
#     go install

RUN go install github.com/hashicorp/terraform@v0.12.19

RUN mkdir -p /workdir/tf-dominos && \
    git clone --depth 1 https://github.com/ndmckinley/terraform-provider-dominos.git && \
    cd terraform-provider-dominos && \
    go mod init terraform-provider-dominos && \
    go get github.com/hashicorp/terraform@v0.12.19

RUN cd terraform-provider-dominos && \
    make

RUN mkdir -p ~/.terraform.d/plugins && \
    mv terraform-provider-dominos/terraform-provider-dominos ~/.terraform.d/plugins && \
    chmod +x ~/.terraform.d/plugins/terraform-provider-dominos

ENTRYPOINT [ "terraform" ]

# RUN mkdir -p /home/.terraform.d/plugins && \
#     wget https://github.com/ndmckinley/terraform-provider-dominos/raw/master/bin/terraform-provider-dominos -O /home/.terraform.d/plugins/terraform-provider-dominos && \
#     chmod +x /home/.terraform.d/plugins/terraform-provider-dominos
