output "integration_role_unique_id" {
  description = "The unique ID of the DSPM integration role"
  value       = try(module.dspm_roles[0].integration_role_unique_id, "")
}

output "scanner_role_unique_id" {
  description = "The unique ID of the DSPM scanner role"
  value       = try(module.dspm_roles[0].scanner_role_unique_id, "")
}

# S3 Log Ingestion Outputs
output "s3_log_role_arn" {
  description = "ARN of the IAM role for S3 log ingestion"
  value       = try(module.realtime_visibility.s3_log_role_arn, "")
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue for CloudTrail log notifications"
  value       = try(module.realtime_visibility.sqs_queue_arn, "")
}

output "sqs_dlq_arn" {
  description = "ARN of the dead letter queue for failed messages"
  value       = try(module.realtime_visibility.sqs_dlq_arn, "")
}

output "sns_subscription_arn" {
  description = "ARN of the SNS subscription linking customer topic to SQS queue"
  value       = try(module.realtime_visibility.sns_subscription_arn, "")
}
