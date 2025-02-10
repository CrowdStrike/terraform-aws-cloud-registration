variable "eventbus_arn" {
  type        = string
  description = "Eventbus ARN to send events to"
}

variable "eventbridge_role_arn" {
  type        = string
  description = "Eventbridge role ARN"
}
