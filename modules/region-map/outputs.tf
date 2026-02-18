output "lambda_s3_bucket" {
  description = "The S3 bucket name for Lambda ZIP packages in this region."
  value       = local.lambda_s3_bucket

  precondition {
    condition     = contains(keys(local.region_bucket_map), var.aws_region)
    error_message = "Unsupported AWS region \"${var.aws_region}\". Check the region_bucket_map in the region-map module for supported regions."
  }
}
