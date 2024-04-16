# Verion -1
#terraform {
#   required_providers {
#     azuread = {
#       source  = "hashicorp/azuread"
#       version = "=2.48.0"
#     }
#   }
# }

# provider "azuread" {
#   # Provider configuration options, if any
# }

# resource "azuread_group" "example_group" {
#   display_name = "Your Group Display Name"
#   mail_enabled = false
#   security_enabled = true
# }


# resource "azuread_access_package_catalog" "example_catalog" {
#   display_name = "Your Access Package Catalog Name"
#   description = "test description"
# }


# resource "azuread_access_package_resource_catalog_association" "example" {
#   catalog_id             = azuread_access_package_catalog.example_catalog.id
#   resource_origin_id     = azuread_group.example_group.object_id
#   resource_origin_system = "AadGroup"
# }

# resource "azuread_access_package" "example" {
#   display_name = "example-package"
#   description  = "Example Package"
#   catalog_id   = azuread_access_package_catalog.example_catalog.id
# }

# resource "azuread_access_package_resource_package_association" "example" {
#   access_package_id               = azuread_access_package.example.id
#   catalog_resource_association_id = azuread_access_package_resource_catalog_association.example.id
# }