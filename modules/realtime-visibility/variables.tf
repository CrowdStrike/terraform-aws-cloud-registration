variable "is_primary_region" {
  type        = bool
  default     = false
  description = "Whether this is the primary region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once."
}

variable "primary_region" {
  description = "Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from agentless_scanning_regions which controls region-specific resource deployment."
  type        = string
}

variable "create_rules" {
  type        = bool
  default     = true
  description = "Set to false if you don't want to enable monitoring in this region"
}

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

variable "eventbridge_role_name" {
  type        = string
  default     = "CrowdStrikeCSPMEventBridge"
  description = "The eventbridge role name"
}

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if you are deploying in gov Falcon"
}

variable "is_gov_commercial" {
  type        = bool
  default     = false
  description = "Set to true if this is a commercial account in gov-cloud"
}

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

variable "eventbus_arn" {
  type        = string
  description = "EventBus ARN(s) to send events to - single ARN for commercial, comma-separated for gov multi-region"
}

variable "resource_prefix" {
  description = "The prefix to be added to all resource names"
  default     = ""
  type        = string
}

variable "resource_suffix" {
  description = "The suffix to be added to all resource names"
  default     = ""
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources that support tagging"
  type        = map(string)
  default     = {}
}

# S3 Log Ingestion Variables
variable "log_ingestion_method" {
  type        = string
  default     = "eventbridge"
  description = "Choose the method for ingesting CloudTrail logs - EventBridge (default) or S3"
}

variable "log_ingestion_s3_bucket_name" {
  type        = string
  default     = ""
  description = "S3 bucket name containing CloudTrail logs (required when log_ingestion_method=s3)"
}

variable "log_ingestion_sns_topic_arn" {
  type        = string
  default     = ""
  description = "SNS topic ARN that publishes S3 object creation events (required when log_ingestion_method=s3)"
}

variable "log_ingestion_s3_bucket_prefix" {
  type        = string
  default     = ""
  description = "Optional S3 bucket prefix/path for CloudTrail logs (when log_ingestion_method=s3)"
}

variable "log_ingestion_kms_key_arn" {
  type        = string
  default     = ""
  description = "Optional KMS key ARN for decrypting S3 objects (when log_ingestion_method=s3)"
}

variable "external_id" {
  type        = string
  default     = ""
  description = "External ID for secure cross-account role assumption"
}


variable "intermediate_role_arn" {
  type        = string
  default     = ""
  description = "CrowdStrike Role ARN for cross-account access"
}
