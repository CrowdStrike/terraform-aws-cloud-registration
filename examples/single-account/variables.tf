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

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be either empty or the 12-digit AWS account ID"
  }
}
