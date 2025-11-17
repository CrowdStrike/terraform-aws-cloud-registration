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

variable "is_gov" {
  type        = bool
  default     = false
  description = "Set to true if you are deploying in gov Falcon"
}

variable "primary_region" {
  description = "Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from agentless_scanning_regions which controls region-specific resource deployment."
  type        = string
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

variable "create_rtvd_rules" {
  type        = bool
  default     = true
  description = "Set to false if you don't want to enable monitoring in this region"
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

variable "cloudtrail_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket for CloudTrail logs"
}

variable "enable_dspm" {
  type        = bool
  default     = false
  description = "Set to true to enable Data Security Posture Managment"
}

variable "enable_vulnerability_scanning" {
  type        = bool
  default     = false
  description = "Set to true to enable Vulnerability Scanning"
}

variable "dspm_role_name" {
  description = "DEPRECATED: Use agentless_scanning_role_name instead. The unique name of the IAM role that DSPM will be assuming"
  type        = string
  default     = ""
}

check "dspm_role_name_deprecation" {
  assert {
    condition     = var.dspm_role_name == ""
    error_message = "DEPRECATION WARNING: 'dspm_role_name' is deprecated. Please use 'agentless_scanning_role_name' instead."
  }
}

variable "dspm_scanner_role_name" {
  description = "DEPRECATED: Use agentless_scanning_scanner_role_name instead. The unique name of the IAM role that CrowdStrike Scanner will be assuming"
  type        = string
  default     = ""
}

check "dspm_scanner_role_name_deprecation" {
  assert {
    condition     = var.dspm_scanner_role_name == ""
    error_message = "DEPRECATION WARNING: 'dspm_scanner_role_name' is deprecated. Please use 'agentless_scanning_scanner_role_name' instead."
  }
}

variable "dspm_regions" {
  description = "DEPRECATED: Use agentless_scanning_regions instead. List of regions where DSPM scanning will be deployed"
  type        = list(string)
  default     = []

  validation {
    condition = length(var.dspm_regions) == 0 || alltrue([
      for region in var.dspm_regions :
      (can(regex("^(?:us|eu|ap|sa|ca|af|me|il)-(?:north|south|east|west|central|northeast|southeast|southwest|northwest)-[1-4]$", region)) ||
      can(regex("^us-gov-(?:east|west)-1$", region)))
    ])
    error_message = "Each element in the dspm_regions list must be a valid AWS region (e.g., 'us-east-1', 'eu-west-2', 'us-gov-east-1', 'us-gov-west-1') that is supported by DSPM."
  }
}

check "dspm_regions_deprecation" {
  assert {
    condition     = length(var.dspm_regions) == 0
    error_message = "DEPRECATION WARNING: 'dspm_regions' is deprecated. Please use 'agentless_scanning_regions' instead."
  }
}


variable "dspm_create_nat_gateway" {
  description = "DEPRECATED: Use agentless_scanning_create_nat_gateway instead. Set to true to create a NAT Gateway for DSPM scanning environments"
  type        = bool
  default     = true
}

check "dspm_create_nat_gateway_deprecation" {
  assert {
    condition     = var.dspm_create_nat_gateway == true
    error_message = "DEPRECATION WARNING: 'dspm_create_nat_gateway' is deprecated. Please use 'agentless_scanning_create_nat_gateway' instead."
  }
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

variable "dspm_integration_role_unique_id" {
  description = "DEPRECATED: Use agentless_scanning_integration_role_unique_id instead. The unique ID of the DSPM integration role"
  default     = ""
  type        = string
}

check "dspm_integration_role_unique_id_deprecation" {
  assert {
    condition     = var.dspm_integration_role_unique_id == ""
    error_message = "DEPRECATION WARNING: 'dspm_integration_role_unique_id' is deprecated. Please use 'agentless_scanning_integration_role_unique_id' instead."
  }
}

variable "dspm_scanner_role_unique_id" {
  description = "DEPRECATED: Use agentless_scanning_scanner_role_unique_id instead. The unique ID of the DSPM scanner role"
  default     = ""
  type        = string
}

check "dspm_scanner_role_unique_id_deprecation" {
  assert {
    condition     = var.dspm_scanner_role_unique_id == ""
    error_message = "DEPRECATION WARNING: 'dspm_scanner_role_unique_id' is deprecated. Please use 'agentless_scanning_scanner_role_unique_id' instead."
  }
}

variable "resource_prefix" {
  description = "The prefix to be added to all resource names"
  default     = "CrowdStrike"
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

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "agentless_scanning_use_custom_vpc" {
  description = "Use existing custom VPC resources for ALL deployment regions (requires agentless_scanning_custom_vpc_resources_map with all regions)"
  type        = bool
  default     = false
}

variable "agentless_scanning_custom_vpc_resources_map" {
  description = <<-EOT
    Map of regions to custom VPC resources for Agentless Scanning deployment.
    Each region can specify existing VPC resources to use instead of creating new ones.

    Example:
    {
      "us-east-1" = {
        vpc            = "vpc-0123456789abcdef0"
        scanner_subnet = "subnet-0123456789abcdef0"
        scanner_sg     = "sg-0123456789abcdef0"
        db_subnet_a    = "subnet-1123456789abcdef0"
        db_subnet_b    = "subnet-2123456789abcdef0"
        db_sg          = "sg-1123456789abcdef0"
      }
    }

    All resource IDs must exist in the specified region.
  EOT

  type = map(object({
    vpc            = string
    scanner_subnet = string
    scanner_sg     = string
    db_subnet_a    = string
    db_subnet_b    = string
    db_sg          = string
  }))
  default = {}
}

variable "agentless_scanning_host_account_id" {
  type        = string
  default     = ""
  description = "The AWS account ID where agentless scanning host resources are deployed"

  validation {
    condition     = var.agentless_scanning_host_account_id == "" || can(regex("^\\d{12}$", var.agentless_scanning_host_account_id))
    error_message = "Agentless scanning host account ID must be empty or 12 digits."
  }
}

variable "agentless_scanning_host_role_name" {
  type        = string
  default     = "CrowdStrikeAgentlessScanningIntegrationRole"
  description = "Name of agentless scanning integration role in host account"

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}

variable "agentless_scanning_host_scanner_role_name" {
  type        = string
  default     = "CrowdStrikeAgentlessScanningScannerRole"
  description = "Name of agentless scanning scanner role in host account"

  validation {
    condition     = can(regex("^$|^[a-zA-Z0-9+=,.@_-]{1,64}$", var.agentless_scanning_host_scanner_role_name))
    error_message = "Role name must be empty or use only alphanumeric and '+=,.@-_' characters, maximum 64 characters."
  }
}

variable "agentless_scanning_role_name" {
  description = "The unique name of the IAM role that Agentless scanning will be assuming"
  type        = string
  default     = "CrowdStrikeAgentlessScanningIntegrationRole"
}

variable "agentless_scanning_scanner_role_name" {
  description = "The unique name of the IAM role that Agentless scanning scanner will be assuming"
  type        = string
  default     = "CrowdStrikeAgentlessScanningScannerRole"
}

variable "agentless_scanning_regions" {
  description = "List of regions where agentless scanning will be deployed"
  type        = list(string)
  default     = ["us-east-1"]

  validation {
    condition     = length(var.agentless_scanning_regions) > 0
    error_message = "At least one agentless scanning region must be specified."
  }

  validation {
    condition = alltrue([
      for region in var.agentless_scanning_regions :
      (can(regex("^(?:us|eu|ap|sa|ca|af|me|il)-(?:north|south|east|west|central|northeast|southeast|southwest|northwest)-[1-4]$", region)) ||
      can(regex("^us-gov-(?:east|west)-1$", region)))
    ])
    error_message = "Each element in the agentless_scanning_regions list must be a valid AWS region (e.g., 'us-east-1', 'eu-west-2', 'us-gov-east-1', 'us-gov-west-1')."
  }
}

variable "agentless_scanning_create_nat_gateway" {
  description = "Set to true to create a NAT Gateway for agentless scanning environments"
  type        = bool
  default     = true
}

variable "agentless_scanning_scanner_role_unique_id" {
  description = "The unique ID of the Agentless scanning scanner role"
  type        = string
  default     = ""
}


variable "agentless_scanning_integration_role_unique_id" {
  description = "The unique ID of the Agentless scanning integration role"
  type        = string
  default     = ""
}