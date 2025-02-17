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

variable "primary_region" {
  type        = string
  description = "The AWS region where resources should be deployed"
}

variable "is_primary_region" {
  type        = bool
  description = "The AWS region where resources should be deployed"
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

variable "organization_id" {
  type        = string
  default     = ""
  description = "The AWS Organization ID. Leave blank if when onboarding single account"
  validation {
    condition     = length(var.account_id) != 0 || length(var.organization_id) != 0
    error_message = "you must provide at least one of these variables: account_id, organization_id"
  }
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
}

variable "enable_sensor_management" {
  type        = bool
  description = "Set to true to install 1Click Sensor Management resources"
}

variable "enable_realtime_visibility" {
  type        = bool
  default     = false
  description = "Set to true to install realtime visibility resources"
}

variable "use_existing_cloudtrail" {
  type        = bool
  default     = false
  description = "Set to true if you already have a cloudtrail"
}

variable "eventbridge_role_name" {
  type        = string
  default     = "CrowdStrikeCSPMEventBridge"
  description = "The eventbridge role name"
}

variable "enable_idp" {
  type        = bool
  default     = false
  description = "Set to true to install Identity Protection resources"
}
