output "agentless_scanning_integration_role_name" {
  description = "The name of the agentless scanning integration role"
  value       = try(module.agentless_scanning_roles[0].integration_role_name, "")

  depends_on = [
    module.agentless_scanning_roles,
  ]
}
