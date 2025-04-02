variable "external_id" {
  type        = string
  description = "Unique identifier provided by CrowdStrike for secure cross-account access"
}

variable "role_name" {
  type        = string
  description = "Name of the asset inventory reader IAM role"
}

variable "intermediate_role_arn" {
  type        = string
  description = "ARN of CrowdStrike's intermediate role"
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
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
