variable "cloudtrail_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for CloudTrail logs"
}

variable "use_existing_cloudtrail" {
  type        = bool
  default     = false
  description = "Whether to use an existing CloudTrail or create a new one"
}

variable "eventbus_arn" {
  type        = string
  description = ""
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile used for this account"
}

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if this is a gov account"
}

variable "is_commercial" {
  type        = bool
  default     = false
  description = "Set to true if this is a gov commercial account"
}

variable "excluded_regions" {
  type        = list(string)
  default     = []
  description = "tbd"
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
}
