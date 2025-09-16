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

variable "dspm_create_nat_gateway" {
  description = "Set to true to create a NAT Gateway for DSPM scanning environments"
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
