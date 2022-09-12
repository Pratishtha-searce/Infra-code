/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
  Versions Details
 *****************************************/

terraform {
  required_version = ">= 0.13.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0, >= 2.12"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0, >= 3.45"
    }
  }
}


provider "google" {}

terraform {
  backend "gcs" {
    bucket = "tfstate-bucket-gcp"
    prefix = "global/networking/vpc_subnets"
  }
}

/******************************************
  VCP & Subnets Details
 *****************************************/

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 4.0"
  project_id   = var.project_id
  network_name = "main-vpc"
  subnets = [
    {
      subnet_name           = "gke-pvt-asia-sth1-main-vpc-subnet"
      subnet_ip             = "10.200.0.0/16"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
  secondary_ranges = {
    "gke-pvt-asia-sth1-main-vpc-subnet" = [
      {
        range_name    = "pod-range"
        ip_cidr_range = "10.201.0.0/16"
      },

      {
        range_name    = "svc-range"
        ip_cidr_range = "10.202.0.0/16"
      },
    ]
  }
}


# /******************************************
#   Resource for External Static IPs
#  *****************************************/

resource "google_compute_address" "address" {
  project = var.project_id
  count   = 1
  name    = "ext-ip${count.index}"
  region  = var.region
}

# /******************************************
#   Cloud Router & Nat Details 
#  *****************************************/

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "main-vpc-nat-router"
  network = module.vpc.network_name
  region  = var.region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.1.0"
  project_id                         = var.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  name                               = "main-vpc-nat"
  nat_ips                            = google_compute_address.address.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_router.router]
}

# /******************************************
#   Firewall Rules Details 
#  *****************************************/

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name
  rules = [{
    name                    = "iap-gooleip-allow-iap-tcp-22-3389-allow-rule"
    description             = "This firewall rule is to allow GCP Cloud IAP IP ranges."
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["35.235.240.0/20"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["allow-iap"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22", "3389"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    },
    {
      name                    = "allow-hc-access-tcp-80-443-allow-rule"
      description             = "This firewall is to allow load balancer health-check"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["209.85.204.0/22", "209.85.152.0/22", "130.211.0.0/22", "35.191.0.0/16"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["allow-hc-access"]
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "default-deny-int-all-all-all-deny-rule"
      description             = "This firewall will deny all egress traffic to internet."
      direction               = "EGRESS"
      priority                = 64000
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow                   = []
      deny = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}

# /******************************************
# 	VPC subnets outputs
#  *****************************************/

output "project_id" {
  value       = module.vpc.project_id
  description = "VPC project id"
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "subnets_names" {
  value       = module.vpc.subnets
  description = "The names of the subnets being created"
}

# /******************************************
#   NAT gateway outputs
#  *****************************************/

output "cloud_nat_name" {
  description = "Name of the Cloud NAT"
  value       = module.cloud-nat.name
}

/******************************************
  Firewall rules outputs
 *****************************************/

output "firewall_rules" {
  value       = module.firewall_rules.firewall_rules
  description = "The details of the firewall rules."
}
