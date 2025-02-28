data "aws_regions" "available" {
  all_regions = true
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

locals {
  target_regions       = contains(var.realtime_visibility_regions, "all") ? data.aws_regions.available.names : var.realtime_visibility_regions
  default_eventbus_arn = "arn:aws:events:${var.primary_region}:${var.account_id}:event-bus/default"

  region_config = {
    for region in local.target_regions : region => {
      eventbus_arn         = local.is_gov_commercial ? (region == var.primary_region ? try(module.realtime_visibility_main[0].eventbridge_lambda_alias, "") : local.default_eventbus_arn) : local.eventbus_arn
      eventbridge_role_arn = local.is_gov_commercial && region == var.primary_region ? null : try(module.realtime_visibility_main[0].eventbridge_role_arn, "")
    }
  }
}

module "rules_us-east-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-east-1") ? 1 : 0
  eventbus_arn         = local.region_config["us-east-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["us-east-1"].eventbridge_role_arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us-east-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-east-2") ? 1 : 0
  eventbus_arn         = local.region_config["us-east-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["us-east-2"].eventbridge_role_arn

  providers = {
    aws = aws.us-east-2
  }
}

module "rules_us-west-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-west-1") ? 1 : 0
  eventbus_arn         = local.region_config["us-west-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["us-west-1"].eventbridge_role_arn

  providers = {
    aws = aws.us-west-1
  }
}

module "rules_us-west-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-west-2") ? 1 : 0
  eventbus_arn         = local.region_config["us-west-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["us-west-2"].eventbridge_role_arn

  providers = {
    aws = aws.us-west-2
  }
}

module "rules_af-south-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "af-south-1") ? 1 : 0
  eventbus_arn         = local.region_config["af-south-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["af-south-1"].eventbridge_role_arn

  providers = {
    aws = aws.af-south-1
  }
}

module "rules_ap-east-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-east-1") ? 1 : 0
  eventbus_arn         = local.region_config["ap-east-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-east-1"].eventbridge_role_arn

  providers = {
    aws = aws.ap-east-1
  }
}

module "rules_ap-south-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-south-1") ? 1 : 0
  eventbus_arn         = local.region_config["ap-south-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-south-1"].eventbridge_role_arn

  providers = {
    aws = aws.ap-south-1
  }
}

module "rules_ap-south-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-south-2") ? 1 : 0
  eventbus_arn         = local.region_config["ap-south-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-south-2"].eventbridge_role_arn

  providers = {
    aws = aws.ap-south-2
  }
}

module "rules_ap-southeast-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-1") ? 1 : 0
  eventbus_arn         = local.region_config["ap-southeast-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-southeast-1"].eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "rules_ap-southeast-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-2") ? 1 : 0
  eventbus_arn         = local.region_config["ap-southeast-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-southeast-2"].eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "rules_ap-southeast-3" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-3") ? 1 : 0
  eventbus_arn         = local.region_config["ap-southeast-3"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-southeast-3"].eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-3
  }
}

module "rules_ap-southeast-4" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-4") ? 1 : 0
  eventbus_arn         = local.region_config["ap-southeast-4"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-southeast-4"].eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-4
  }
}

module "rules_ap-northeast-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-1") ? 1 : 0
  eventbus_arn         = local.region_config["ap-northeast-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-northeast-1"].eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "rules_ap-northeast-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-2") ? 1 : 0
  eventbus_arn         = local.region_config["ap-northeast-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-northeast-2"].eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "rules_ap-northeast-3" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-3") ? 1 : 0
  eventbus_arn         = local.region_config["ap-northeast-3"].eventbus_arn
  eventbridge_role_arn = local.region_config["ap-northeast-3"].eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "rules_ca-central-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ca-central-1") ? 1 : 0
  eventbus_arn         = local.region_config["ca-central-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["ca-central-1"].eventbridge_role_arn

  providers = {
    aws = aws.ca-central-1
  }
}

module "rules_eu-central-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-central-1") ? 1 : 0
  eventbus_arn         = local.region_config["eu-central-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-central-1"].eventbridge_role_arn

  providers = {
    aws = aws.eu-central-1
  }
}

module "rules_eu-west-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-1") ? 1 : 0
  eventbus_arn         = local.region_config["eu-west-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-west-1"].eventbridge_role_arn

  providers = {
    aws = aws.eu-west-1
  }
}

module "rules_eu-west-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-2") ? 1 : 0
  eventbus_arn         = local.region_config["eu-west-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-west-2"].eventbridge_role_arn

  providers = {
    aws = aws.eu-west-2
  }
}

module "rules_eu-west-3" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-3") ? 1 : 0
  eventbus_arn         = local.region_config["eu-west-3"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-west-3"].eventbridge_role_arn

  providers = {
    aws = aws.eu-west-3
  }
}

module "rules_eu-south-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-south-1") ? 1 : 0
  eventbus_arn         = local.region_config["eu-south-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-south-1"].eventbridge_role_arn

  providers = {
    aws = aws.eu-south-1
  }
}

module "rules_eu-south-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-south-2") ? 1 : 0
  eventbus_arn         = local.region_config["eu-south-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-south-2"].eventbridge_role_arn

  providers = {
    aws = aws.eu-south-2
  }
}

module "rules_eu-north-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-north-1") ? 1 : 0
  eventbus_arn         = local.region_config["eu-north-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-north-1"].eventbridge_role_arn

  providers = {
    aws = aws.eu-north-1
  }
}

module "rules_eu-central-2" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-central-2") ? 1 : 0
  eventbus_arn         = local.region_config["eu-central-2"].eventbus_arn
  eventbridge_role_arn = local.region_config["eu-central-2"].eventbridge_role_arn

  providers = {
    aws = aws.eu-central-2
  }
}

module "rules_me-south-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "me-south-1") ? 1 : 0
  eventbus_arn         = local.region_config["me-south-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["me-south-1"].eventbridge_role_arn

  providers = {
    aws = aws.me-south-1
  }
}

module "rules_me-central-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "me-central-1") ? 1 : 0
  eventbus_arn         = local.region_config["me-central-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["me-central-1"].eventbridge_role_arn

  providers = {
    aws = aws.me-central-1
  }
}

module "rules_sa-east-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "sa-east-1") ? 1 : 0
  eventbus_arn         = local.region_config["sa-east-1"].eventbus_arn
  eventbridge_role_arn = local.region_config["sa-east-1"].eventbridge_role_arn

  providers = {
    aws = aws.sa-east-1
  }
}

module "rules_us-gov-east-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-gov-east-1") ? 1 : 0
  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-gov-east-1
  }
}

module "rules_us-gov-west-1" {
  source               = "../realtime-visibility-rules/"
  count                = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-gov-west-1") ? 1 : 0
  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-gov-west-1
  }
}
