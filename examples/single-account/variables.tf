variable "falcon_client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client ID"
}

variable "falcon_client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be either empty or the 12-digit AWS account ID"
  }
}

variable "me" {
  type        = string
  default     = "unspecified"
  description = "The user running terraform"
}

variable "agentless_scanning_create_nat_gateway" {
  description = "Set to true to create a NAT Gateway for agentless scanning environments"
  type        = bool
  default     = true
}

variable "dspm_s3_access" {
  description = "Apply permissions for S3 bucket scanning"
  type        = bool
  default     = true
}

variable "dspm_dynamodb_access" {
  description = "Apply permissions for DynamoDB table scanning"
  type        = bool
  default     = true
}

variable "dspm_rds_access" {
  description = "Apply permissions for RDS instance scanning"
  type        = bool
  default     = true
}

variable "dspm_redshift_access" {
  description = "Apply permissions for Redshift cluster scanning"
  type        = bool
  default     = true
}

variable "dspm_ebs_access" {
  description = "Apply permissions for EBS scanning"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "agentless_scanning_use_custom_vpc" {
  description = "Use existing custom VPC resources for ALL deployment regions (requires agentless_scanning_custom_vpc_resources_map with all regions)"
  type        = bool
  default     = false
}

variable "agentless_scanning_custom_vpc_resources_map" {
  description = "Map of region-specific VPC resources for existing VPC deployment. Keys are region names, values are objects containing VPC resource IDs."
  type = map(object({
    vpc            = string
    scanner_subnet = string
    scanner_sg     = string
    db_subnet_a    = string
    db_subnet_b    = string
    db_sg          = string
  }))
  default = {}
}

variable "agentless_scanning_host_account_id" {
  type        = string
  default     = ""
  description = "The AWS account ID where agentless scanning host resources are deployed"

  validation {
    condition     = var.agentless_scanning_host_account_id == "" || can(regex("^\\d{12}$", var.agentless_scanning_host_account_id))
    error_message = "Agentless scanning host account ID must be empty or 12 digits."
  }
}

variable "agentless_scanning_host_role_name" {
  type        = string
  default     = "CrowdStrikeAgentlessScanningIntegrationRole"
  description = "Name of agentless scanning integration role in host account"

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}

variable "agentless_scanning_host_scanner_role_name" {
  type        = string
  default     = "CrowdStrikeAgentlessScanningScannerRole"
  description = "Name of agentless scanning scanner role in host account"

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_scanner_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}
