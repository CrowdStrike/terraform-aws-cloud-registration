# Region-specific prefixes and bucket IDs for constructing regional
# cloudconnect-templates S3 bucket names. Must stay in sync with
# cs_aws_region_map.yaml.tmpl in the CSPM/configs repository.
locals {
  region_bucket_map = {
    "us-east-1"      = { prefix = "use1", bucket_region_id = "4721cdb0" }
    "us-east-2"      = { prefix = "use2", bucket_region_id = "0c19f3dd" }
    "us-west-1"      = { prefix = "usw1", bucket_region_id = "810f8878" }
    "us-west-2"      = { prefix = "usw2", bucket_region_id = "bce32e5c" }
    "af-south-1"     = { prefix = "afs1", bucket_region_id = "ef8595a0" }
    "ap-east-1"      = { prefix = "ape1", bucket_region_id = "70bb0ea3" }
    "ap-northeast-1" = { prefix = "apne1", bucket_region_id = "145f171b" }
    "ap-northeast-2" = { prefix = "apne2", bucket_region_id = "68bbfe3e" }
    "ap-northeast-3" = { prefix = "apne3", bucket_region_id = "d4160e46" }
    "ap-southeast-1" = { prefix = "apse1", bucket_region_id = "db65e1e6" }
    "ap-south-1"     = { prefix = "aps1", bucket_region_id = "d41357ff" }
    "ca-central-1"   = { prefix = "cac1", bucket_region_id = "315e8647" }
    "eu-central-1"   = { prefix = "euc1", bucket_region_id = "edd048dc" }
    "eu-north-1"     = { prefix = "eun1", bucket_region_id = "ae865f0d" }
    "eu-south-1"     = { prefix = "eus1", bucket_region_id = "e006fd77" }
    "eu-west-1"      = { prefix = "euw1", bucket_region_id = "25924530" }
    "eu-west-2"      = { prefix = "euw2", bucket_region_id = "5e56e088" }
    "eu-west-3"      = { prefix = "euw3", bucket_region_id = "f154c304" }
    "me-south-1"     = { prefix = "mes1", bucket_region_id = "9f7d433b" }
    "sa-east-1"      = { prefix = "sae1", bucket_region_id = "589dbb5f" }
    "ap-southeast-2" = { prefix = "apse2", bucket_region_id = "804dcf46" }
    "ap-southeast-3" = { prefix = "apse3", bucket_region_id = "2353cfc8" }
    "me-central-1"   = { prefix = "mec1", bucket_region_id = "7b30ccf6" }
    "eu-central-2"   = { prefix = "euc2", bucket_region_id = "6b50b33b" }
    "eu-south-2"     = { prefix = "eus2", bucket_region_id = "b5ff3cb9" }
    "ap-south-2"     = { prefix = "aps2", bucket_region_id = "ab74afb6" }
    "ap-southeast-4" = { prefix = "apse4", bucket_region_id = "d5e19596" }
    "ca-west-1"      = { prefix = "caw1", bucket_region_id = "b1fef251" }
    "il-central-1"   = { prefix = "ilc1", bucket_region_id = "a02bc6ec" }
    "mx-central-1"   = { prefix = "mxc1", bucket_region_id = "8db1e6e1" }
    "ap-southeast-5" = { prefix = "apse5", bucket_region_id = "0ab89571" }
    "ap-southeast-7" = { prefix = "apse7", bucket_region_id = "25b2cfcf" }
  }

  # Look up the current region's info.
  region_info = lookup(local.region_bucket_map, var.aws_region, null)

  # Construct the regional Lambda S3 bucket name.
  lambda_s3_bucket = local.region_info != null ? "cs-prod-cloudconnect-templates-${local.region_info.prefix}-${local.region_info.bucket_region_id}" : ""
}
