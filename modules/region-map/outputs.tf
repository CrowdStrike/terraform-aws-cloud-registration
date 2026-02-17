output "lambda_s3_bucket" {
  description = "The S3 bucket name for Lambda ZIP packages in this region."
  value       = local.lambda_s3_bucket
}

output "lambda_s3_key_prefix" {
  description = "The S3 key prefix for Lambda ZIP packages (aws/lambda for regional buckets, aws for legacy)."
  value       = local.lambda_s3_key_prefix
}
