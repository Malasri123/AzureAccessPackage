terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.48.0"
    }
  }
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
  environment   = var.environment
}


# Azure AD Groups
resource "azuread_group" "department_groups" {
  count          = length(var.group_names)
  display_name   = var.group_names[count.index]
  mail_enabled   = var.mail_enabled
  security_enabled = var.security_enabled
}

# Access Package Catalog
resource "azuread_access_package_catalog" "department_access_catalog" {
  display_name = var.access_package_catalog_display_name
  description  = var.access_package_catalog_description
}

# Access Package
resource "azuread_access_package" "department_access_package" {
  display_name = var.access_package_display_name
  description  = var.access_package_description
  catalog_id   = azuread_access_package_catalog.department_access_catalog.id
}

# Associate Groups with Access Package
resource "azuread_access_package_resource_catalog_association" "department_group_association" {
  count                   = length(azuread_group.department_groups)
  catalog_id              = azuread_access_package_catalog.department_access_catalog.id
  resource_origin_id      = azuread_group.department_groups[count.index].object_id
  resource_origin_system  = var.resource_origin_system
}

# Associate Groups with Access Package 
resource "azuread_access_package_resource_package_association" "department_access_package_association" {
  count                          = length(azuread_access_package_resource_catalog_association.department_group_association)
  access_package_id              = azuread_access_package.department_access_package.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.department_group_association[count.index].id
}

# Azure AD User for Requester
resource "azuread_user" "access_package_requester" {
  display_name        = var.requester_display_name
  user_principal_name = var.requester_user_principal_name
  mail_nickname       = var.requester_mail_nickname
  password            = var.requester_password
}

# Local-exec provisioner to assign user as requester
resource "null_resource" "assign_access_package_requester" {
  provisioner "local-exec" {
    command = <<-EOT
      az ad access-package assignment add \
        --access-package-id ${azuread_access_package.department_access_package.id} \
        --principal-id ${azuread_user.access_package_requester.object_id} \
        --principal-type User \
        --assignment-type Requester \
        --output json
    EOT
  }
  depends_on = [azuread_access_package.department_access_package, azuread_user.access_package_requester]
}