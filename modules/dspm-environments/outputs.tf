output "crowdstrike_kms_key" {
  description = "The arn of the KMS key that DSPM will use"
  value       = aws_kms_key.crowdstrike_kms_key.arn
}

output "vpc_id" {
  description = "ID of the VPC (either created or custom)"
  value       = var.use_custom_vpc ? var.region_vpc_config.vpc : aws_vpc.vpc[0].id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.db_subnet_group.name
}

output "redshift_subnet_group_name" {
  description = "Name of the Redshift subnet group"
  value       = aws_redshift_subnet_group.redshift_subnet_group.name
}

output "scanner_subnet_id" {
  description = "ID of the scanner subnet"
  value       = var.use_custom_vpc ? var.region_vpc_config.scanner_subnet : aws_subnet.private_subnet[0].id
}

output "scanner_security_group_id" {
  description = "ID of the scanner security group"
  value       = var.use_custom_vpc ? var.region_vpc_config.scanner_sg : aws_security_group.ec2_security_group[0].id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = var.use_custom_vpc ? var.region_vpc_config.db_sg : aws_security_group.db_security_group[0].id
}

output "environment_ssm_parameter_name" {
  description = "Name of the SSM parameter containing environment configuration"
  value       = aws_ssm_parameter.scan_environment_parameter.name
}
