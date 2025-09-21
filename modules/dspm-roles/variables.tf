variable "dspm_role_name" {
  description = "The unique name of the IAM role that CrowdStrike will be assuming"
  type        = string
  default     = "CrowdStrikeDSPMIntegrationRole"
}

variable "dspm_scanner_role_name" {
  description = "The unique name of the IAM role that CrowdStrike Scanner will be assuming"
  type        = string
  default     = "CrowdStrikeDSPMScannerRole"
}

variable "falcon_client_id" {
  description = "CrowdStrike client ID"
  type        = string
  nullable    = false
  validation {
    condition     = length(var.falcon_client_id) == 32 && can(regex("^[a-fA-F0-9]+$", var.falcon_client_id))
    error_message = "The client_id must be a valid v4 uuid (without dashes), containing only hexadecimal characters and exactly 32 characters long."
  }
}

variable "falcon_client_secret" {
  description = "CrowdStrike client secret"
  type        = string
  nullable    = false
}

variable "intermediate_role_arn" {
  description = "ARN of the CrowdStrike assuming role"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@\\-_/]+$", var.intermediate_role_arn))
    error_message = "The provided value for cs_role_arn must be a valid AWS IAM role ARN."
  }
}

variable "external_id" {
  description = "Unique ID for customer"
  type        = string
  nullable    = false

  validation {
    condition = (
      length(var.external_id) >= 1 &&
      length(var.external_id) <= 256 &&
      can(regex("^[\\p{L}\\p{M}\\p{S}\\p{N}\\p{P}]+$", var.external_id))
    )
    error_message = "The provided value for the field external_id must be a valid AWS external ID."
  }
}

variable "dspm_regions" {
  description = "The regions in which DSPM scanning environments will be created"
  type        = list(string)
  default     = ["us-east-1"]

  validation {
    condition     = length(var.dspm_regions) > 0
    error_message = "At least one DSPM region must be specified."
  }

  validation {
    condition = alltrue([
      for region in var.dspm_regions :
      can(regex("^(?:us|eu|ap|sa|ca|af|me|il)-(?:north|south|east|west|central|northeast|southeast|southwest|northwest)-[1-4]$", region))
    ])
    error_message = "Each element in the dspm_regions list must be a valid AWS region (e.g., 'us-east-1', 'eu-west-2') that is supported by DSPM."
  }
}

variable "agentless_scanning_use_custom_vpc" {
  description = "Whether to use existing custom VPC resources for ALL deployment regions (requires agentless_scanning_custom_vpc_resources_map with all regions)"
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

variable "tags" {
  description = "A map of tags to add to all resources that support tagging"
  type        = map(string)
  default     = {}
}

variable "agentless_scanning_host_account_id" {
  type        = string
  default     = ""
  description = "The AWS account ID where DSPM host resources are deployed"

  validation {
    condition     = var.agentless_scanning_host_account_id == "" || can(regex("^\\d{12}$", var.agentless_scanning_host_account_id))
    error_message = "Agentless scanning host account ID must be empty or 12 digits."
  }
}

variable "agentless_scanning_host_role_name" {
  type        = string
  default     = "CrowdStrikeDSPMIntegrationRole"
  description = "Name of agentless scanning integration role in host account"

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}

variable "agentless_scanning_host_scanner_role_name" {
  type        = string
  default     = "CrowdStrikeDSPMScannerRole"
  description = "Name of angentless scanning scanner role in host account"]

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_scanner_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  validation {
    condition     = length(var.account_id) == 0 || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be either empty or the 12-digit AWS account ID"
  }
}
