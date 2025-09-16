output "integration_role_arn" {
  description = "The unique ID of the DSPM integration role"
  value       = module.dspm_roles[0].dspm_role_arn
}

output "scanner_role_arn" {
  description = "The unique ID of the DSPM scanner role"
  value       = module.dspm_roles[0].dspm_scanner_role_arn
}