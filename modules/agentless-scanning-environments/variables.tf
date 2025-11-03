variable "deployment_name" {
  description = "The deployment name will be used in environment installation"
  type        = string
  default     = "dspm-environment"
}

variable "integration_role_unique_id" {
  description = "The unique ID of the agentless scanning integration role"
  type        = string
}

variable "scanner_role_unique_id" {
  description = "The unique ID of the agentless scanning scanner role"
  type        = string
}

variable "use_custom_vpc" {
  description = "Whether to use existing custom VPC resources instead of creating new ones. When true, region_vpc_config must be provided."
  type        = bool
  default     = false
}

variable "region_vpc_config" {
  description = "VPC configuration for the current region"
  type = object({
    vpc            = string
    scanner_subnet = string
    scanner_sg     = string
    db_subnet_a    = string
    db_subnet_b    = string
    db_sg          = string
  })
  default = null

  validation {
    condition = var.region_vpc_config == null || (
      can(regex("^vpc-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.vpc)) &&
      can(regex("^subnet-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.scanner_subnet)) &&
      can(regex("^sg-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.scanner_sg)) &&
      can(regex("^subnet-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.db_subnet_a)) &&
      can(regex("^subnet-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.db_subnet_b)) &&
      can(regex("^sg-[a-f0-9]{8}(?:[a-f0-9]{9})?$", var.region_vpc_config.db_sg))
    )
    error_message = "All AWS resource IDs must be valid format: VPC IDs must start with 'vpc-', subnet IDs must start with 'subnet-', and security group IDs must start with 'sg-', followed by 8 or 17 hexadecimal characters."
  }
}

variable "agentless_scanning_create_nat_gateway" {
  description = "Set to true to create a NAT Gateway for agentless scanning environments"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources that support tagging"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
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

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  validation {
    condition     = length(var.account_id) == 0 || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be either empty or the 12-digit AWS account ID"
  }
}
