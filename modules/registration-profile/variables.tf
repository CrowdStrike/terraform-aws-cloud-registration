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
  description = "The AWS profile to be used for this registration"
}

variable "primary_region" {
  type        = string
  description = "The AWS region where resources should be deployed"
}

variable "is_gov" {
  type        = bool
  description = "Set to true if this is a gov account"
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

variable "excluded_regions" {
  type        = list(string)
  default     = []
  description = "The regions to be excluded for Realtime Visibility monitoring"
}

variable "enable_idp" {
  type        = bool
  default     = false
  description = "Set to true to install Identity Protection resources"
}

variable "external_id" {
  type        = string
  default     = ""
  description = "The external ID used to assume the AWS reader role"
}

variable "intermediate_role_arn" {
  type        = string
  default     = ""
  description = "The intermediate role that is allowed to assume the reader role"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "The ARN of the reader role"
}

variable "eventbus_arn" {
  type        = string
  default     = ""
  description = "Eventbus ARN to send events to"
}

variable "eventbridge_role_arn" {
  type        = string
  default     = ""
  description = "Eventbridge role ARN"
}

variable "cloudtrail_bucket_name" {
  type        = string
  default     = ""
  description = ""
}

variable "enable_dspm" {
  type        = bool
  default     = false
  description = " Set to true to enable Data Security Posture Managment"
}

variable "dspm_regions" {
  type        = list(string)
  default     = []
  description = "The list of regions where DSPM should be enabled"
}

variable "dspm_role_arn" {
  type        = string
  default     = ""
  description = "The role ARN used for Data Security Posture Managment integration"
}
