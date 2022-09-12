# Google Cloud Storage Module

This module makes it easy to create a GCS bucket, and assign basic permissions on it to arbitrary users.

Features:

- Multi-Regional/Regional Bucket
- Bucket storage class
- Bucket versioning

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.7 |
| google | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.0 |

## Configure a Service Account

In order to execute this module you must have a Service Account with the
following project roles:

- [roles/storage.admin](https://cloud.google.com/iam/docs/understanding-roles)

## Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Cloud Storage API: storage-component.googleapis.com

## Usage

Basic usage of this module is as follows:

* GCS Bucket

```hcl
module "tfstate_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"

  name              = "cogility-terraform-state-us-wst4-01"
  project_id        = var.project_id
  location          = var.location
  storage_class     = "STANDARD"
  versioning        = true
  labels = {
    "env" = "cogynt",
    "purpose" = "terraform",
    "createdby" = "terraform"
  }
}
```

* Provide the variables values to the modules from terraform.tfvars file.

```hcl
project_id    = "xxx"
location      = "us-west4"
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project to create the bucket in. | string | - | yes |
| location | The location of the bucket | string | - | yes |


## Outputs

| Name | Description |
|------|-------------|
| bucket | The created bucket details |  

* Then perform the following commands in the directory:

   `terraform init` to get the plugins

   `terraform plan` to see the infrastructure plan

   `terraform apply` to apply the infrastructure build

   `terraform destroy` to destroy the built infrastructure
