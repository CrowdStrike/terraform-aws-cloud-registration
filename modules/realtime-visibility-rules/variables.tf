variable "eventbus_arn" {
  type        = string
  description = "Eventbus ARN to send events to"
}

variable "eventbridge_role_arn" {
  type        = string
  description = "Eventbridge role ARN"
}

# variable "is_gov" {
#   type        = bool
#   default     = false
#   description = "Set to true if this is a gov account"
# }
#
# variable "is_commercial" {
#   type        = bool
#   default     = false
#   description = "Set to true if this is a gov commercial account"
# }
#
# variable "excluded_regions" {
#   type        = list(string)
#   default     = []
#   description = "tbd"
# }
#
