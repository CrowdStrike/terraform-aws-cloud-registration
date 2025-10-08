output "agentless_scanning_integration_role_name" {
  description = "The name of the agentless scanning integration role"
  value       = try(module.dspm_roles[0].integration_role_name, "")

  depends_on = [
    module.dspm_roles,
  ]
}
