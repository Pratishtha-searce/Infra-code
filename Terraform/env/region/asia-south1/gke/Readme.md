# Project GKE Private Cluster and NodePool Module
​
This module makes it easy to create the GKE Private Cluster for the GCP Network.
​
- GKE Private Cluster

- Node Pool
​
## Usage
Basic usage of this module is as follows:
​
​
* GKE Private Cluster
​
```hcl
module "gke_private_cluster" {
  source                                = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                            = var.project_id
  name                                  = "cogility-us-wst4-cluster-02"
  region                                = var.region
  network                               = "cogility-main-01-vpc"
  subnetwork                            = "cogility-pvt-us-wst4-subnet-02"
  ip_range_pods                         = "cogility-pvt-us-wst4-subnet-pod-02"
  ip_range_services                     = "cogility-pvt-us-wst4-subnet-svc-02"
  regional                              = true
  create_service_account                = false
  http_load_balancing                   = true
  network_policy                        = true
  horizontal_pod_autoscaling            = true
  enable_private_endpoint               = false
  enable_private_nodes                  = true
  deploy_using_private_endpoint         = true
  master_ipv4_cidr_block                = "10.3.0.0/28"
  remove_default_node_pool              = true
  initial_node_count                    = 0
  service_account                       = "cogility-gke-clustr-sa@cogynt.iam.gserviceaccount.com"
  master_authorized_networks            = []

  cluster_resource_labels            = {
    "env" : "cogynt-02"
  }
  kubernetes_version                 = "1.22.8-gke.200"
```
​
* Node Pool

```hcl
node_pools = [
    {
      name                           = "worker"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 3
      max_count                      = 20
      disk_size_gb                   = 100
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    },
    {
      name                           = "imply-data"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 3
      max_count                      = 3
      disk_size_gb                   = 50
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    },
    {
      name                           = "storage"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 6
      max_count                      = 6
      disk_size_gb                   = 50
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    }
  ]
  node_pools_labels = {
    all = {}

    worker = {
      "px/enabled"         = "false",
      "k8s.cogynt.io/node" = "worker",
    }

    storage = {
      "px/enabled"         = "true",
      "k8s.cogynt.io/node" = "storage",
    }

    imply-data = {
      "px/enabled"         = "false",
      "k8s.cogynt.io/node" = "imply-data",
    }
  }
}
```

* Provide the variables values to the modules from terraform.tfvars file.
​
```hcl
project_id  = "xxx"
region      = "us-west4"
```
​

* Then perform the following commands in the directory:

   `terraform init` to get the plugins

   `terraform plan` to see the infrastructure plan

   `terraform apply` to apply the infrastructure build

   `terraform destroy` to destroy the built infrastructure
