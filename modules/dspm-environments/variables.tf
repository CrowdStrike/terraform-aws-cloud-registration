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
