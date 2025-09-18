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
