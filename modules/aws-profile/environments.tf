module "dspm_environment_us_east_1" {
  count                      = (contains(var.dspm_regions, "us-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.us-east-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_us_east_2" {
  count                      = (contains(var.dspm_regions, "us-east-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.us-east-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_us_west_1" {
  count                      = (contains(var.dspm_regions, "us-west-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.us-west-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_us_west_2" {
  count                      = (contains(var.dspm_regions, "us-west-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.us-west-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_af_south_1" {
  count                      = (contains(var.dspm_regions, "af-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.af-south-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_east_1" {
  count                      = (contains(var.dspm_regions, "ap-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-east-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_south_1" {
  count                      = (contains(var.dspm_regions, "ap-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-south-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_south_2" {
  count                      = (contains(var.dspm_regions, "ap-south-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-south-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_northeast_1" {
  count                      = (contains(var.dspm_regions, "ap-northeast-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-northeast-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_northeast_2" {
  count                      = (contains(var.dspm_regions, "ap-northeast-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-northeast-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_northeast_3" {
  count                      = (contains(var.dspm_regions, "ap-northeast-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-northeast-3
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_southeast_1" {
  count                      = (contains(var.dspm_regions, "ap-southeast-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-southeast-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_southeast_2" {
  count                      = (contains(var.dspm_regions, "ap-southeast-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-southeast-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_southeast_3" {
  count                      = (contains(var.dspm_regions, "ap-southeast-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-southeast-3
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ap_southeast_4" {
  count                      = (contains(var.dspm_regions, "ap-southeast-4") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ap-southeast-4
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_ca_central_1" {
  count                      = (contains(var.dspm_regions, "ca-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.ca-central-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_central_1" {
  count                      = (contains(var.dspm_regions, "eu-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-central-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_central_2" {
  count                      = (contains(var.dspm_regions, "eu-central-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-central-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_north_1" {
  count                      = (contains(var.dspm_regions, "eu-north-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-north-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_south_1" {
  count                      = (contains(var.dspm_regions, "eu-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-south-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_south_2" {
  count                      = (contains(var.dspm_regions, "eu-south-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-south-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_west_1" {
  count                      = (contains(var.dspm_regions, "eu-west-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-west-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_west_2" {
  count                      = (contains(var.dspm_regions, "eu-west-2") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-west-2
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_eu_west_3" {
  count                      = (contains(var.dspm_regions, "eu-west-3") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.eu-west-3
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_me_central_1" {
  count                      = (contains(var.dspm_regions, "me-central-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.me-central-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_me_south_1" {
  count                      = (contains(var.dspm_regions, "me-south-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.me-south-1
  }
  depends_on = [module.dspm_roles]
}

module "dspm_environment_sa_east_1" {
  count                      = (contains(var.dspm_regions, "sa-east-1") && var.enable_dspm && !var.is_gov) ? 1 : 0
  source                     = "../dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = module.dspm_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.dspm_roles[0].scanner_role_unique_id
  tags                       = var.tags
  providers = {
    aws = aws.sa-east-1
  }
  depends_on = [module.dspm_roles]
}
