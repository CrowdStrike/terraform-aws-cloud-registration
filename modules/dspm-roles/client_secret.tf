resource "aws_secretsmanager_secret" "client_secrets" {
  #checkov:skip=CKV_AWS_149:The secret is encrypted using an AWS managed key
  name = "CrowdStrikeDSPMClientSecret"

  tags = {
    (local.crowdstrike_tag_key)        = local.crowdstrike_tag_value
    (local.logical_tag_key)            = "ClientSecrets"
    (local.deployment_regions_tag_key) = join("/", var.dspm_regions)
  }
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "client_secrets_version" {
  secret_id = aws_secretsmanager_secret.client_secrets.id
  secret_string = jsonencode({
    ClientId     = var.falcon_client_id
    ClientSecret = var.falcon_client_secret
  })
}
