Azure Access Package Management using Terraform
This repository contains Terraform code to manage Azure Active Directory (Azure AD) access packages, allowing department managers to grant access to specific sets of resources for their teams.

Prerequisites
Before you begin, make sure you have the following installed:

Terraform
Azure CLI
Azure AD 
Terraform Configuration
Providers
hashicorp/azuread: Used for managing Azure AD resources.

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.48.0"
    }
  }
}

provider "azuread" {
  # Provider configuration options, if any
}
Resources
azuread_group: Creates Azure AD groups.
azuread_access_package_catalog: Defines an access package catalog.
azuread_access_package: Creates an access package.
azuread_access_package_resource_catalog_association: Associates Azure AD groups with the access package.
azuread_access_package_resource_package_association: Associates resources with the access package.
azuread_user: Creates an Azure AD user for requester.
null_resource with local-exec provisioner: Executes Azure CLI command to assign a user as a requester.

Usage
Initialize Terraform:
terraform init

Review the Terraform plan:
terraform plan

Apply the Terraform configuration:
terraform apply

Assigning Requesters
To assign a user as a requester to an access package, a local-exec provisioner with an Azure CLI command is used. Make sure to replace placeholders with actual values before running Terraform commands.

# Local-exec provisioner to assign user as requester
resource "null_resource" "assign_requester" {
  provisioner "local-exec" {
    command = <<-EOT
      az ad access-package assignment add \
        --access-package-id ${azuread_access_package.example.id} \
        --principal-id ${azuread_user.example.object_id} \
        --principal-type User \
        --assignment-type Requester \
        --output json
    EOT
  }
  depends_on = [azuread_access_package.example, azuread_user.example]
}
Cleanup
To remove all created resources, run:

terraform destroy