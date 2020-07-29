#Download base image ubuntu 18.04
FROM ubuntu:18.04
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG s3_bucket
ARG key_pair

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION
ENV s3_bucket $s3_bucket
ENV key_pair $key_pair

# LABEL about the custom image
LABEL description="This is custom Docker Image for Kubernetes with Terraform"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update && \
    apt install wget -y && \
    apt install zip -y && \
    apt install graphviz -y && \
    apt install curl -y && \
    apt install ssh -y && \
    apt-get install jq -y && \
    apt install -y nano && \
    apt install -y awscli && \
    wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    unzip terraform*.zip && \
    rm terraform*.zip && \
    mv terraform /usr/local/bin && \
    mkdir /devops && \
    mkdir /devops/modules && \
    mkdir /devops/terraform && \
    mkdir /devops/docs && \
    mkdir /devops/app && \
    mkdir /devops/keyPair && \
    mkdir /devops/mychart && \
    mkdir /devops/shell_script && \
    curl -Lo /devops/terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v0.10.0-rc.1/terraform-docs-v0.10.0-rc.1-$(uname | tr '[:upper:]' '[:lower:]')-amd64 && \
    chmod +x /devops/terraform-docs

# Define working directory.
WORKDIR /devops/terraform
COPY modules /devops/modules
COPY terraform /devops/terraform
COPY terraform/run.sh /devops/terraform
COPY app /devops/app
COPY mychart /devops/mychart
COPY shell_script /devops/shell_script
COPY keyPair /devops/keyPair

# Define default command.
CMD ["bash"]
