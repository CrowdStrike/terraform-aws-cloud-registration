variable "aws_region" {
  description = "The AWS region to look up in the region map."
  type        = string
}

variable "fallback_bucket" {
  description = "The S3 bucket name to use if the region is not in the region map."
  type        = string
}
