variable "deployment_name" {
  description = "The deployment name will be used in environment installation"
  type        = string
  default     = "dspm-environment"
}

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

variable "integration_role_unique_id" {
  description = "The unique ID of the DSPM integration role"
  type        = string
}

variable "scanner_role_unique_id" {
  description = "The unique ID of the DSPM scanner role"
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
}

variable "dspm_create_nat_gateway" {
  description = "Set to true to create a NAT Gateway for DSPM scanning environments"
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
  description = "The AWS account ID where DSPM host resources are deployed"
}

variable "agentless_scanning_host_role_name" {
  type        = string
  default     = "CrowdStrikeDSPMIntegrationRole"
  description = "Name of DSPM integration role in host account"
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
