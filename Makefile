all-Resource:
	cd Terraform/env/global/tfstate-gcs; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve
	cd Terraform/env/global/vpc_subnets; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve
	cd Terraform/env/region/asia-south1/gke; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve



specific-global-Resource:
	$(call check_defined, dir_name, Please set the dir_name to apply. Values should be tfstate-gcs or vpc_subnets)
	cd Terraform/env/global/${dir_name}; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve

specific-regional-Resource:
	$(call check_defined, dir_name, Please set the ENV to apply. Values should be dev, test, uat or prod)
	cd Terraform/env/region/asia-south1/${dir_name}; \
    terraform init && terraform fmt && terraform validate && terraform plan && terraform apply --var-file=terraform.tfvars --auto-approve


# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
