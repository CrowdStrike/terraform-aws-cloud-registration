output "dspm_role_arn" {
  description = "The arn of the IAM role that CrowdStrike will be assuming"
  value       = aws_iam_role.crowdstrike_aws_dspm_integration_role.arn
}

output "integration_role_unique_id" {
  description = "The unique ID of the DSPM integration role"
  value       = aws_iam_role.crowdstrike_aws_dspm_integration_role.unique_id
}

output "dspm_scanner_role_arn" {
  description = "The arn of the IAM role that CrowdStrike Scanner will be assuming"
  value       = aws_iam_role.crowdstrike_aws_dspm_scanner_role.arn
}

output "scanner_role_unique_id" {
  description = "The unique ID of the DSPM scanner role"
  value       = aws_iam_role.crowdstrike_aws_dspm_scanner_role.unique_id
}
