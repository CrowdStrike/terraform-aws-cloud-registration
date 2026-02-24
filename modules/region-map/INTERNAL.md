## Introduction

This Terraform module provides a mapping from AWS region names to regional S3 bucket identifiers used for storing Lambda deployment packages. It is consumed by other modules that need to locate Lambda ZIP packages in the correct regional bucket.

## Usage

```hcl
module "region_map" {
  source     = "CrowdStrike/cloud-registration/aws//modules/region-map/"
  aws_region = "us-east-1"
}
```

## Providers

No providers.
## Resources

No resources.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to look up in the region map. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#output\_lambda\_s3\_bucket) | The S3 bucket name for Lambda ZIP packages in this region. |