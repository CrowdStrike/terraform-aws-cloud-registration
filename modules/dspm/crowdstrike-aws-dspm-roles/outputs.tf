output "dspm_role_arn" {
  description = "The arn of the IAM role that CrowdStrike will be assuming"
  value       = aws_iam_role.crowdstrike_aws_dspm_integration_role.arn
}

output "dspm_scanner_role_arn" {
  description = "The arn of the IAM role that CrowdStrike Scanner will be assuming"
  value       = aws_iam_role.crowdstrike_aws_dspm_scanner_role.arn
}
