variable "cloudtrail_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for CloudTrail logs"
}

variable "use_existing_cloudtrail" {
  type        = bool
  default     = false
  description = "Whether to use an existing CloudTrail or create a new one"
}

variable "is_organization_trail" {
  type        = bool
  default     = false
  description = "Whether the Cloudtrail to be created is an organization trail"
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
}

variable "role_name" {
  type        = string
  default     = "CrowdStrikeCSPMEventBridge"
  description = "The eventbridge role name"
}
