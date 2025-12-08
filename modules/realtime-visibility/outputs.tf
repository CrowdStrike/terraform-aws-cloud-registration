output "eventbridge_lambda_alias" {
  value       = try(aws_lambda_alias.eventbridge[0].arn, "")
  description = "The AWS lambda alias to forward events to"
}

# S3 Log Ingestion Outputs
output "s3_log_role_arn" {
  value       = try(aws_iam_role.s3_log_role[0].arn, "")
  description = "ARN of the IAM role for S3 log ingestion"
}

output "sqs_queue_arn" {
  value       = try(aws_sqs_queue.cloudtrail_logs_sqs[0].arn, "")
  description = "ARN of the SQS queue for CloudTrail log notifications"
}

output "sqs_dlq_arn" {
  value       = try(aws_sqs_queue.cloudtrail_logs_dlq[0].arn, "")
  description = "ARN of the dead letter queue for failed messages"
}

output "sns_subscription_arn" {
  value       = try(aws_sns_topic_subscription.cloudtrail_logs_sns_subscription[0].arn, "")
  description = "ARN of the SNS subscription linking customer topic to SQS queue"
}
