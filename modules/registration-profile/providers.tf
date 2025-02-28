provider "aws" {
  profile = var.aws_profile
  region  = var.primary_region
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-east-1"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-east-2"
  region                      = "us-east-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-west-1"
  region                      = "us-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-west-2"
  region                      = "us-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "af-south-1"
  region                      = "af-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-east-1"
  region                      = "ap-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-south-1"
  region                      = "ap-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-south-2"
  region                      = "ap-south-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-southeast-1"
  region                      = "ap-southeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-southeast-2"
  region                      = "ap-southeast-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-southeast-3"
  region                      = "ap-southeast-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-southeast-4"
  region                      = "ap-southeast-4"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-northeast-1"
  region                      = "ap-northeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-northeast-2"
  region                      = "ap-northeast-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ap-northeast-3"
  region                      = "ap-northeast-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "ca-central-1"
  region                      = "ca-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-central-1"
  region                      = "eu-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-west-1"
  region                      = "eu-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-west-2"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-west-3"
  region                      = "eu-west-3"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-south-1"
  region                      = "eu-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-south-2"
  region                      = "eu-south-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-north-1"
  region                      = "eu-north-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "eu-central-2"
  region                      = "eu-central-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "me-south-1"
  region                      = "me-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "me-central-1"
  region                      = "me-central-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "sa-east-1"
  region                      = "sa-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-gov-east-1"
  region                      = "us-gov-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
provider "aws" {
  profile                     = var.aws_profile
  alias                       = "us-gov-west-1"
  region                      = "us-gov-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
