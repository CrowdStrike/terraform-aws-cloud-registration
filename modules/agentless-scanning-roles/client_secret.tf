resource "aws_secretsmanager_secret" "client_secrets" {
  #checkov:skip=CKV_AWS_149:The secret is encrypted using an AWS managed key
  name = "CrowdStrikeDSPMClientSecret"

  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key)        = local.crowdstrike_tag_value
      (local.logical_tag_key)            = "ClientSecrets"
      (local.deployment_regions_tag_key) = join("/", var.agentless_scanning_regions)
    }
  )
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "client_secrets_version" {
  secret_id = aws_secretsmanager_secret.client_secrets.id
  # The write-only input, when set, keeps the secret out of state and plan files.
  secret_string = var.falcon_client_secret_wo_version == null ? jsonencode({
    ClientId     = var.falcon_client_id
    ClientSecret = var.falcon_client_secret
  }) : null
  secret_string_wo = var.falcon_client_secret_wo_version == null ? null : jsonencode({
    ClientId     = var.falcon_client_id
    ClientSecret = var.falcon_client_secret_wo
  })
  secret_string_wo_version = var.falcon_client_secret_wo_version
}
