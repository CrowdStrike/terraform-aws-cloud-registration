output "crowdstrike_kms_key" {
  description = "The arn of the KMS key that DSPM will use"
  value       = aws_kms_key.crowdstrike_kms_key.arn
}

