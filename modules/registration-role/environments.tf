module "dspm-environment-us-east-1" {
  count = (contains(var.dspm_regions, "us-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "us-east-1"
  providers = {
    aws = aws.us-east-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-us-east-2" {
  count = (contains(var.dspm_regions, "us-east-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "us-east-2"
  providers = {
    aws = aws.us-east-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-us-west-1" {
  count = (contains(var.dspm_regions, "us-west-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "us-west-1"
  providers = {
    aws = aws.us-west-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-us-west-2" {
  count = (contains(var.dspm_regions, "us-west-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "us-west-2"
  providers = {
    aws = aws.us-west-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-af-south-1" {
  count = (contains(var.dspm_regions, "af-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "af-south-1"
  providers = {
    aws = aws.af-south-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-east-1" {
  count = (contains(var.dspm_regions, "ap-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-east-1"
  providers = {
    aws = aws.ap-east-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-south-1" {
  count = (contains(var.dspm_regions, "ap-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-south-1"
  providers = {
    aws = aws.ap-south-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-south-2" {
  count = (contains(var.dspm_regions, "ap-south-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-south-2"
  providers = {
    aws = aws.ap-south-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-northeast-1" {
  count = (contains(var.dspm_regions, "ap-northeast-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-northeast-1"
  providers = {
    aws = aws.ap-northeast-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-northeast-2" {
  count = (contains(var.dspm_regions, "ap-northeast-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-northeast-2"
  providers = {
    aws = aws.ap-northeast-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-northeast-3" {
  count = (contains(var.dspm_regions, "ap-northeast-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-northeast-3"
  providers = {
    aws = aws.ap-northeast-3
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-southeast-1" {
  count = (contains(var.dspm_regions, "ap-southeast-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-southeast-1"
  providers = {
    aws = aws.ap-southeast-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-southeast-2" {
  count = (contains(var.dspm_regions, "ap-southeast-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-southeast-2"
  providers = {
    aws = aws.ap-southeast-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-southeast-3" {
  count = (contains(var.dspm_regions, "ap-southeast-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-southeast-3"
  providers = {
    aws = aws.ap-southeast-3
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ap-southeast-4" {
  count = (contains(var.dspm_regions, "ap-southeast-4") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ap-southeast-4"
  providers = {
    aws = aws.ap-southeast-4
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-ca-central-1" {
  count = (contains(var.dspm_regions, "ca-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "ca-central-1"
  providers = {
    aws = aws.ca-central-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-central-1" {
  count = (contains(var.dspm_regions, "eu-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-central-1"
  providers = {
    aws = aws.eu-central-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-central-2" {
  count = (contains(var.dspm_regions, "eu-central-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-central-2"
  providers = {
    aws = aws.eu-central-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-north-1" {
  count = (contains(var.dspm_regions, "eu-north-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-north-1"
  providers = {
    aws = aws.eu-north-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-south-1" {
  count = (contains(var.dspm_regions, "eu-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-south-1"
  providers = {
    aws = aws.eu-south-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-south-2" {
  count = (contains(var.dspm_regions, "eu-south-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-south-2"
  providers = {
    aws = aws.eu-south-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-west-1" {
  count = (contains(var.dspm_regions, "eu-west-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-west-1"
  providers = {
    aws = aws.eu-west-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-west-2" {
  count = (contains(var.dspm_regions, "eu-west-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-west-2"
  providers = {
    aws = aws.eu-west-2
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-eu-west-3" {
  count = (contains(var.dspm_regions, "eu-west-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "eu-west-3"
  providers = {
    aws = aws.eu-west-3
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-me-central-1" {
  count = (contains(var.dspm_regions, "me-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "me-central-1"
  providers = {
    aws = aws.me-central-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-me-south-1" {
  count = (contains(var.dspm_regions, "me-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "me-south-1"
  providers = {
    aws = aws.me-south-1
  }
  depends_on = [module.dspm-roles]
}

module "dspm-environment-sa-east-1" {
  count = (contains(var.dspm_regions, "sa-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-environments.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  region = "sa-east-1"
  providers = {
    aws = aws.sa-east-1
  }
  depends_on = [module.dspm-roles]
}
