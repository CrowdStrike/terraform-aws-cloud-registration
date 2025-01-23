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
  type = string
}

variable "profile" {
  type = string
}

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if this is a gov account"
}

variable "excluded_regions" {
  type        = list(string)
  default     = []
  description = "tbd"
}


