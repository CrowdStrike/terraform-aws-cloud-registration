output "eventbridge_role_arn" {
  value       = aws_iam_role.eventbridge.arn
  description = "The ARN of the role used for eventbrige rules"
}

output "eventbridge_lambda_alias" {
  value       = try(aws_lambda_alias.eventbridge.0.arn, "")
  description = "The AWS lambda alias to forward events to"
}
