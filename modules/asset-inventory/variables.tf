variable "external_id" {
  type        = string
  description = "Unique identifier provided by CrowdStrike for secure cross-account access"
}

variable "use_existing_iam_reader_role" {
  type = bool
  default = false
  description = "Set to true if you intend to use an existing IAM role for asset inventory"
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

variable "tags" {
  description = "A map of tags to add to all resources that support tagging"
  type        = map(string)
  default     = {}
}
