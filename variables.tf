variable "client_id" {
  description = "Azure AD application client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure AD application client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
  sensitive   = true
}

variable "environment" {
    description = "Azure AD environemnt"
    type = string
    sensitive = false
}

variable "group_names" {
  description = "List of Azure AD group names"
  type        = list(string)
  default     = ["Cloud", "Devops"]
}

variable "mail_enabled" {
  description = "Flag to enable/disable mail for Azure AD group"
  type        = bool
  default     = false
}

variable "security_enabled" {
  description = "Flag to enable/disable security for Azure AD group"
  type        = bool
  default     = true
}

variable "access_package_catalog_display_name" {
  description = "Display name for Access Package Catalog"
  type        = string
  default     = "Migrationcatalog"
}

variable "access_package_catalog_description" {
  description = "Description for Access Package Catalog"
  type        = string
  default     = "This access package is used to create a new access package catalog and associated policies using Terraform"
}

variable "access_package_display_name" {
  description = "Display name for Access Package"
  type        = string
  default     = "Migration-package"
}

variable "access_package_description" {
  description = "Description for Access Package"
  type        = string
  default     = "Access package for IT department resources"
}

variable "resource_origin_system" {
  description = "Resource origin system for Azure AD access package"
  type        = string
  default     = "AadGroup"
}

variable "requester_display_name" {
  description = "Display name for requester"
  type        = string
  default     = "IT Department Requester"
}

variable "requester_user_principal_name" {
  description = "User principal name for requester"
  type        = string
  default     = "it.requester@microsoft.com"
}

variable "requester_mail_nickname" {
  description = "Mail nickname for requester"
  type        = string
  default     = "it.requester"
}

variable "requester_password" {
  description = "Password for requester"
  type        = string
  default     = "Itdepartment@999"
}