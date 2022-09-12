# Networking Module

This module makes it easy to create Network, Subnetwork, External IP, NAT, Firewall Rules for the GCP Network.


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

- [roles/compute.networkAdmin](https://cloud.google.com/nat/docs/using-nat#iam_permissions)

## Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com


## Usage

* Provide the variables values to the modules from terraform.tfvars file.

```hcl
project_id    = "xxx"
region        = "us-west4"
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project where subnet will be created | `string` | n/a | yes |
| region | The Region to deploy subnet | `string` | n/a | yes | 


## Outputs

| Name | Description |
|------|-------------|
| project_id | VPC project id |
| network_name | The name of the VPC being created |
| subnets_names | The names of the subnets being created |
| cloud_nat_name | Name of the Cloud NAT |
| firewall_rules | The details of the firewall rules |



* Then perform the following commands in the directory:

   `terraform init` to get the plugins

   `terraform plan` to see the infrastructure plan

   `terraform apply` to apply the infrastructure build

   `terraform destroy` to destroy the built infrastructure
