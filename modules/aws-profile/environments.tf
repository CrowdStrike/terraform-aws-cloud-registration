module "agentless_scanning_environment_us_east_1" {
  count                              = (contains(local.agentless_scanning_regions, "us-east-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = var.agentless_scanning_use_custom_vpc ? lookup(var.agentless_scanning_custom_vpc_resources_map, "us-east-1", null) : null
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.us-east-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_us_east_2" {
  count                              = (contains(local.agentless_scanning_regions, "us-east-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "us-east-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.us-east-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_us_west_1" {
  count                              = (contains(local.agentless_scanning_regions, "us-west-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "us-west-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.us-west-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_us_west_2" {
  count                              = (contains(local.agentless_scanning_regions, "us-west-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "us-west-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.us-west-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_af_south_1" {
  count                              = (contains(local.agentless_scanning_regions, "af-south-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "af-south-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.af-south-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_east_1" {
  count                              = (contains(local.agentless_scanning_regions, "ap-east-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-east-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-east-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_south_1" {
  count                              = (contains(local.agentless_scanning_regions, "ap-south-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-south-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-south-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_south_2" {
  count                              = (contains(local.agentless_scanning_regions, "ap-south-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-south-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-south-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_northeast_1" {
  count                              = (contains(local.agentless_scanning_regions, "ap-northeast-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-northeast-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-northeast-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_northeast_2" {
  count                              = (contains(local.agentless_scanning_regions, "ap-northeast-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-northeast-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-northeast-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_northeast_3" {
  count                              = (contains(local.agentless_scanning_regions, "ap-northeast-3") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-northeast-3", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-northeast-3
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_southeast_1" {
  count                              = (contains(local.agentless_scanning_regions, "ap-southeast-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-southeast-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-southeast-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_southeast_2" {
  count                              = (contains(local.agentless_scanning_regions, "ap-southeast-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-southeast-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-southeast-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_southeast_3" {
  count                              = (contains(local.agentless_scanning_regions, "ap-southeast-3") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-southeast-3", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-southeast-3
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ap_southeast_4" {
  count                              = (contains(local.agentless_scanning_regions, "ap-southeast-4") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ap-southeast-4", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ap-southeast-4
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_ca_central_1" {
  count                              = (contains(local.agentless_scanning_regions, "ca-central-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "ca-central-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.ca-central-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_central_1" {
  count                              = (contains(local.agentless_scanning_regions, "eu-central-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-central-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-central-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_central_2" {
  count                              = (contains(local.agentless_scanning_regions, "eu-central-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-central-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-central-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_north_1" {
  count                              = (contains(local.agentless_scanning_regions, "eu-north-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-north-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-north-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_south_1" {
  count                              = (contains(local.agentless_scanning_regions, "eu-south-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-south-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-south-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_south_2" {
  count                              = (contains(local.agentless_scanning_regions, "eu-south-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-south-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-south-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_west_1" {
  count                              = (contains(local.agentless_scanning_regions, "eu-west-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-west-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-west-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_west_2" {
  count                              = (contains(local.agentless_scanning_regions, "eu-west-2") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-west-2", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-west-2
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_eu_west_3" {
  count                              = (contains(local.agentless_scanning_regions, "eu-west-3") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "eu-west-3", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.eu-west-3
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_me_central_1" {
  count                              = (contains(local.agentless_scanning_regions, "me-central-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "me-central-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.me-central-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_me_south_1" {
  count                              = (contains(local.agentless_scanning_regions, "me-south-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "me-south-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.me-south-1
  }
  depends_on = [module.agentless_scanning_roles]
}

module "agentless_scanning_environment_sa_east_1" {
  count                              = (contains(local.agentless_scanning_regions, "sa-east-1") && (var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                             = "../agentless-scanning-environments/"
  integration_role_unique_id         = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id             = module.agentless_scanning_roles[0].scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  use_custom_vpc                     = var.agentless_scanning_use_custom_vpc
  region_vpc_config                  = lookup(var.agentless_scanning_custom_vpc_resources_map, "sa-east-1", null)
  vpc_cidr_block                     = var.vpc_cidr_block
  tags                               = var.tags
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name
  account_id                         = local.aws_account
  providers = {
    aws = aws.sa-east-1
  }
  depends_on = [module.agentless_scanning_roles]
}

# US Regions
moved {
  from = module.dspm_environment_us_east_1
  to   = module.agentless_scanning_environment_us_east_1
}

moved {
  from = module.dspm_environment_us_east_2
  to   = module.agentless_scanning_environment_us_east_2
}

moved {
  from = module.dspm_environment_us_west_1
  to   = module.agentless_scanning_environment_us_west_1
}

moved {
  from = module.dspm_environment_us_west_2
  to   = module.agentless_scanning_environment_us_west_2
}

# Africa
moved {
  from = module.dspm_environment_af_south_1
  to   = module.agentless_scanning_environment_af_south_1
}

# Asia Pacific
moved {
  from = module.dspm_environment_ap_east_1
  to   = module.agentless_scanning_environment_ap_east_1
}

moved {
  from = module.dspm_environment_ap_south_1
  to   = module.agentless_scanning_environment_ap_south_1
}

moved {
  from = module.dspm_environment_ap_south_2
  to   = module.agentless_scanning_environment_ap_south_2
}

moved {
  from = module.dspm_environment_ap_northeast_1
  to   = module.agentless_scanning_environment_ap_northeast_1
}

moved {
  from = module.dspm_environment_ap_northeast_2
  to   = module.agentless_scanning_environment_ap_northeast_2
}

moved {
  from = module.dspm_environment_ap_northeast_3
  to   = module.agentless_scanning_environment_ap_northeast_3
}

moved {
  from = module.dspm_environment_ap_southeast_1
  to   = module.agentless_scanning_environment_ap_southeast_1
}

moved {
  from = module.dspm_environment_ap_southeast_2
  to   = module.agentless_scanning_environment_ap_southeast_2
}

moved {
  from = module.dspm_environment_ap_southeast_3
  to   = module.agentless_scanning_environment_ap_southeast_3
}

moved {
  from = module.dspm_environment_ap_southeast_4
  to   = module.agentless_scanning_environment_ap_southeast_4
}

# Canada
moved {
  from = module.dspm_environment_ca_central_1
  to   = module.agentless_scanning_environment_ca_central_1
}

# Europe
moved {
  from = module.dspm_environment_eu_central_1
  to   = module.agentless_scanning_environment_eu_central_1
}

moved {
  from = module.dspm_environment_eu_central_2
  to   = module.agentless_scanning_environment_eu_central_2
}

moved {
  from = module.dspm_environment_eu_north_1
  to   = module.agentless_scanning_environment_eu_north_1
}

moved {
  from = module.dspm_environment_eu_south_1
  to   = module.agentless_scanning_environment_eu_south_1
}

moved {
  from = module.dspm_environment_eu_south_2
  to   = module.agentless_scanning_environment_eu_south_2
}

moved {
  from = module.dspm_environment_eu_west_1
  to   = module.agentless_scanning_environment_eu_west_1
}

moved {
  from = module.dspm_environment_eu_west_2
  to   = module.agentless_scanning_environment_eu_west_2
}

moved {
  from = module.dspm_environment_eu_west_3
  to   = module.agentless_scanning_environment_eu_west_3
}

# Middle East
moved {
  from = module.dspm_environment_me_central_1
  to   = module.agentless_scanning_environment_me_central_1
}

moved {
  from = module.dspm_environment_me_south_1
  to   = module.agentless_scanning_environment_me_south_1
}

# South America
moved {
  from = module.dspm_environment_sa_east_1
  to   = module.agentless_scanning_environment_sa_east_1
}
