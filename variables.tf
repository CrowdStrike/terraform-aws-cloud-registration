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

variable "aws_profile" {
  type        = string
  description = "AWS profile to be used when creating resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region to be used when creating resources"
}
variable "external_id" {
  type        = string
  description = ""
}

variable "is_commercial" {
  type        = bool
  default     = false
  description = "Set to true if this is a commercial account in govcloud"
}

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if this is a gov account"
}

variable "custom_role_name" {
  type        = string
  default     = ""
  description = "Custom role name for Asset Inventory integration"
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  # validation {
  #   condition     = length(var.account_id) == 0 && can(regex("^[0-9]{12}$", var.account_id))
  #   error_message = "account_id must be either empty or the 12-digit AWS account ID"
  # }
}

variable "organization_id" {
  type        = string
  default     = ""
  description = "The AWS Organization ID. Leave blank if when onboarding single account"
  # validation {
  #   condition     = length(var.account_id) != 0 || length(var.organization_id) != 0
  #   error_message = "you must provide at least one of these variables: account_id, organization_id"
  # }
}

variable "organizational_unit_ids" {
  type        = list(string)
  default     = []
  description = "The Organizational Unit IDs. Leave blank when deploying to root OU"
}

########################
# real time visibility #
########################

variable "enable_realtime_visibility" {
  type        = bool
  default     = false
  description = "Set to true to enable realtime visibility"
}

variable "use_existing_cloudtrail" {
  type        = bool
  default     = false
  description = "tbd"
}

########################
# identity protection  #
########################
variable "enable_idp" {
  type        = bool
  default     = false
  description = "Set to true to enable Identity Protection"
}

#############################
# 1 click sensor management #
#############################

variable "enable_sensor_management" {
  type        = bool
  description = "Set to true to enable 1Click Sensor Management"
}

###################
# DSPM            #
###################
variable "enable_dspm" {
  type        = bool
  default     = false
  description = " Set to true to enable Data Security Posture Managment"
}

variable "dspm_regions" {
  type        = list(string)
  description = "The list of regions where DSPM should be enabled"
}

variable "dspm_custom_role" {
  type        = string
  default     = ""
  description = "The custom IAM role name for Data Security Posture Managment integration"
}
