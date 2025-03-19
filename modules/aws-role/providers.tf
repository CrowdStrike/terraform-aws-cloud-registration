provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-east-1"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-east-2"
  region                      = "us-east-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-west-1"
  region                      = "us-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-west-2"
  region                      = "us-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "af-south-1"
  region                      = "af-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-east-1"
  region                      = "ap-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-south-1"
  region                      = "ap-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-south-2"
  region                      = "ap-south-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-southeast-1"
  region                      = "ap-southeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-southeast-2"
  region                      = "ap-southeast-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-southeast-3"
  region                      = "ap-southeast-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-southeast-4"
  region                      = "ap-southeast-4"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-northeast-1"
  region                      = "ap-northeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-northeast-2"
  region                      = "ap-northeast-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ap-northeast-3"
  region                      = "ap-northeast-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "ca-central-1"
  region                      = "ca-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-central-1"
  region                      = "eu-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-west-1"
  region                      = "eu-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-west-2"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-west-3"
  region                      = "eu-west-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-south-1"
  region                      = "eu-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-south-2"
  region                      = "eu-south-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-north-1"
  region                      = "eu-north-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "eu-central-2"
  region                      = "eu-central-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "me-south-1"
  region                      = "me-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "me-central-1"
  region                      = "me-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "sa-east-1"
  region                      = "sa-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-gov-east-1"
  region                      = "us-gov-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  alias                       = "us-gov-west-1"
  region                      = "us-gov-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}
