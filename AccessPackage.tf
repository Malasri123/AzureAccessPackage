# Verion -1
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

# Azure AD Groups
resource "azuread_group" "example_group" {
  count          = length(var.group_names)
  display_name   = var.group_names[count.index]
  mail_enabled   = false
  security_enabled = true
}

variable "group_names" {
  description = "List of Azure AD group names"
  type        = list(string)
  default     = ["Group1", "Group2"] # Add your group names here
}

# Access Package Catalog
resource "azuread_access_package_catalog" "example_catalog" {
  display_name = "Your Access Package Catalog Name"
  description  = "test description"
}

# Access Package
resource "azuread_access_package" "example" {
  display_name = "example-package"
  description  = "Example Package"
  catalog_id   = azuread_access_package_catalog.example_catalog.id
}

# Associate Groups with Access Package
resource "azuread_access_package_resource_catalog_association" "example" {
  count                   = length(azuread_group.example_group)
  catalog_id              = azuread_access_package_catalog.example_catalog.id
  resource_origin_id      = azuread_group.example_group[count.index].object_id
  resource_origin_system  = "AadGroup"
}

# Associate Groups with Access Package Package
resource "azuread_access_package_resource_package_association" "example" {
  count                          = length(azuread_access_package_resource_catalog_association.example)
  access_package_id              = azuread_access_package.example.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.example[count.index].id
}

# Azure AD User for Requester
resource "azuread_user" "example" {
  display_name = "Requester Name"
  user_principal_name = "requester@example.com"
  mail_nickname = "requester"
  password = "YourStrongPasswordHere"
}

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