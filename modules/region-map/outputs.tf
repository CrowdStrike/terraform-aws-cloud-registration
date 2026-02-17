output "lambda_s3_bucket" {
  description = "The S3 bucket name for Lambda ZIP packages in this region."
  value       = local.lambda_s3_bucket
}
