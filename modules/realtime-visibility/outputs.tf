output "eventbridge_lambda_alias" {
  value       = try(aws_lambda_alias.eventbridge[0].arn, "")
  description = "The AWS lambda alias to forward events to"
}
