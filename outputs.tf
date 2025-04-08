output "integration_role_unique_id" {
  description = "The unique ID of the DSPM integration role"
  value       = try(module.dspm_roles[0].integration_role_unique_id, "")
}

output "scanner_role_unique_id" {
  description = "The unique ID of the DSPM scanner role"
  value       = try(module.dspm_roles[0].scanner_role_unique_id, "")
}
