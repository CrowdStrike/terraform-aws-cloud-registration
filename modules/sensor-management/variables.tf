variable "external_id" {
  type        = string
  description = "Unique identifier provided by CrowdStrike for secure cross-account access"
}

variable "intermediate_role_arn" {
  type        = string
  description = "ARN of CrowdStrike's intermediate role"
}

variable "client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client ID"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}

variable "credentials_storage_mode" {
  type        = string
  default     = "secret"
  description = "Storage mode for Falcon API credentials: 'lambda' (Lambda environment variables) or 'secret' (AWS Secret)"

  validation {
    condition     = contains(["lambda", "secret"], var.credentials_storage_mode)
    error_message = "credentials_storage_mode must be 'lambda' or 'secret'"
  }
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The name of the policy used to set the permissions boundary for IAM roles"
}

