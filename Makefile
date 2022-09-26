all-resource:
    # gcs bucket
    cd Terraform/env/global/tfstate-gcs; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve
    # vpc subnets
    cd Terraform/env/global/vpc_subnets; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve
    # GKE cluster
    cd Terraform/env/region/asia-south1/gke; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve

specific-global-resource:
    # specific global resources creation
    $(call check_defined, dir_name, Please set the dir_name to apply. Values should be tfstate-gcs or vpc_subnets)
    cd Terraform/env/global/${dir_name}; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve

specific-regional-resource:
    # specific regional resources creation
    $(call check_defined, dir_name,  Please set the dir_name to apply. Values should be gke)
    cd Terraform/env/region/asia-south1/${dir_name}; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve
# pass the make command like this - make all-resource
# for specific  global and regional - make specific-global-resource/specific-regional-resource dir_name="name of the directory where terraform configuration files are present."
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))