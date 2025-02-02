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

variable "cs_account_number" {
  description = "CrowdStrike account number"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]{12}$", var.cs_account_number))
    error_message = "The provided value for the field cs_account_number must be a valid AWS account number."
  }
}

variable "cs_role_name" {
  description = "Name of CrowdStrike assuming role"
  type = string
  nullable = false
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
}

