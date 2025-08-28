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
  description = "Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm_regions which controls region-specific resource deployment."
  type        = string
}

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if your falcon cloud is gov"
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

variable "account_type" {
  type        = string
  default     = "commercial"
  description = "Account type can be either 'commercial' or 'gov'"
  validation {
    condition     = var.account_type == "commercial" || var.account_type == "gov"
    error_message = "must be either 'commercial' or 'gov'"
  }
}

variable "organization_id" {
  type        = string
  default     = ""
  description = "The AWS Organization ID. Leave blank when onboarding single account"
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

variable "realtime_visibility_regions" {
  type        = list(string)
  default     = ["all"]
  description = "The list of regions where Real-time visibility and detection should be enabled. Use [\"all\"] to onboard all regions"
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

variable "iam_role_name" {
  type        = string
  default     = ""
  description = "The name of the reader role"
}

variable "use_existing_iam_reader_role" {
  type        = bool
  default     = false
  description = "Set to true if you want to use an existing IAM role for asset inventory"
}

variable "eventbus_arn" {
  type        = string
  default     = ""
  description = "Eventbus ARN to send events to"
}

variable "eventbridge_role_name" {
  type        = string
  default     = "CrowdStrikeCSPMEventBridge"
  description = "The eventbridge role name"
}

variable "cloudtrail_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket for CloudTrail logs"
}

variable "enable_dspm" {
  type        = bool
  default     = false
  description = " Set to true to enable Data Security Posture Managment"
}

variable "dspm_role_name" {
  description = "The unique name of the IAM role that DSPM will be assuming"
  type        = string
  default     = "CrowdStrikeDSPMIntegrationRole"
}

variable "dspm_scanner_role_name" {
  description = "The unique name of the IAM role that CrowdStrike Scanner will be assuming"
  type        = string
  default     = "CrowdStrikeDSPMScannerRole"
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
      can(regex("^(?:us|eu|ap|sa|ca|af|me|il)-(?:north|south|east|west|central|northeast|southeast|southwest|northwest)-[1-4]$", region))
    ])
    error_message = "Each element in the dspm_regions list must be a valid AWS region (e.g., 'us-east-1', 'eu-west-2') that is supported by DSPM."
  }
}

variable "resource_prefix" {
  description = "The prefix to be added to all resource names"
  default     = "CrowdStrike-"
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
