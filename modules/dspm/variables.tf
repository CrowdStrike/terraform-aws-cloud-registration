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

variable "client_id" {
  description = "CrowdStrike client ID"
  type = string
  nullable = false
  validation {
    condition     = length(var.client_id) == 32 && can(regex("^[a-fA-F0-9]+$", var.client_id))
    error_message = "The client_id must be a valid v4 uuid (without dashes), containing only hexadecimal characters and exactly 32 characters long."
  }
}

variable "client_secret" {
  description = "CrowdStrike client secret"
  type = string
  nullable = false
}

variable "cs_role_arn" {
  description = "ARN of the CrowdStrike assuming role"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@\\-_/]+$", var.cs_role_arn))
    error_message = "The provided value for cs_role_arn must be a valid AWS IAM role ARN."
  }
}


variable "external_id" {
  description = "Unique ID for customer"
  type        = string
  nullable    = false

  validation {
    condition     = (
      length(var.external_id) >= 1 &&
      length(var.external_id) <= 256 &&
      can(regex("^[\\p{L}\\p{M}\\p{S}\\p{N}\\p{P}]+$", var.external_id))
    )
    error_message = "The provided value for the field external_id must be a valid AWS external ID."
  }
}

variable "region" {
  description = "The region from which the DSPM terraform roles module will run"
  type = string
  default = "us-east-1"
  condition = contains(local.aws_regions_set, region)
}

variable "aws_profile" {
  description = "The AWS profile from which to run the modules"
  type = string
  default = "default"
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
      contains(local.aws_regions_set, region)
    ])
    error_message = "Each element in the dspm_regions list must be a valid AWS region (e.g., 'us-east-1', 'eu-west-2') that is supported by DSPM."
  }
}
