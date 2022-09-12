FROM gcr.io/cloud-builders/gcloud

ENV TERRAFORM_VERSION=1.2.9

RUN apt-get update && apt-get install wget unzip


RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && rm -rf /var/tmp/*
