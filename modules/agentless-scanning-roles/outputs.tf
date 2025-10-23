output "integration_role_name" {
  description = "The arn of the IAM role that CrowdStrike will be assuming"
  value       = aws_iam_role.crowdstrike_aws_agentless_scanning_integration_role.name
}

output "integration_role_unique_id" {
  description = "The unique ID of the DSPM integration role"
  value       = aws_iam_role.crowdstrike_aws_agentless_scanning_integration_role.unique_id
}

output "scanner_role_name" {
  description = "The arn of the IAM role that CrowdStrike Scanner will be assuming"
  value       = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.name
}

output "scanner_role_unique_id" {
  description = "The unique ID of the DSPM scanner role"
  value       = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.unique_id
}
