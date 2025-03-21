# pylint: disable=W1401

"""CrowdStrike FCS Terraform Generator
 _______                        __ _______ __        __ __
|   _   .----.-----.--.--.--.--|  |   _   |  |_.----|__|  |--.-----.
|.  1___|   _|  _  |  |  |  |  _  |   1___|   _|   _|  |    <|  -__|
|.  |___|__| |_____|________|_____|____   |____|__| |__|__|__|_____|
|:  1   |                         |:  1   |
|::.. . |   CROWDSTRIKE FALCON    |::.. . |
`-------'                         `-------'


Generate the Terraform modules necessary to onboard an AWS Organization with CrowdStrike FCS

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

@author: ryan.payne@crowdstrike.com
"""

import os
from argparse import ArgumentParser
import configparser
import boto3

class FileConfiguration:  # pylint: disable=R0902
    """Class to hold running configuration."""
    def __init__(self, file_name):
        self.file = configparser.ConfigParser(converters={'list': lambda x: [i.strip() for i in x.split(',')]})
        self.file.read(file_name)
        self.target = self.file['target']['TargetDirectory']
        self.falcon_client_id = self.file['falcon.credentials']['ClientId']
        self.falcon_client_secret = self.file['falcon.credentials']['ClientSecret']
        self.aws_auth_method = self.file['aws.auth']['AuthMethod']
        if 'role' in self.aws_auth_method:
            self.cross_account_role = self.file['aws.auth']['CrossAccountRole']
        self.primary_region = self.file['aws.config']['PrimaryRegion']
        self.ous = self.file.getlist('aws.config', 'TargetOUs')
        self.permissions_boundary = self.file['aws.config']['PermissionsBoundary']
        self.realtime_visibility = self.file['falcon.features']['RealtimeVisibility']
        self.idp = self.file['falcon.features']['IDP']
        self.sensor_management = self.file['falcon.features']['SensorManagement']
        self.dspm = self.file['falcon.features']['DSPM']
        self.iam_role_name = self.file['asset.inventory']['IAMRoleName']
        self.existing_cloudtrail = self.file['realtime.visibility']['ExistingCloudTrail']
        if not self.file['realtime.visibility']['Regions']:
            self.realtime_visibility_regions = "all"
        else:
            self.realtime_visibility_regions = self.file['realtime.visibility']['Regions']
        if not self.file['dspm']['DSPMRegions']:
            self.dspm_regions = ""
        else:
            self.dspm_regions = self.file['dspm']['DSPMRegions']

class ArgConfiguration:  # pylint: disable=R0902
    """Class to hold running configuration."""
    def __init__(self, args):
        self.config_file = args.config_file
        self.target = args.target
        self.falcon_client_id = args.falcon_client_id
        self.falcon_client_secret = args.falcon_client_secret
        self.aws_auth_method = args.aws_auth_method
        self.cross_account_role = args.cross_account_role
        self.primary_region = args.primary_region
        if not args.permissions_boundary:
            self.permissions_boundary = ""
        else:
            self.permissions_boundary = args.permissions_boundary
        self.realtime_visibility = args.realtime_visibility
        self.idp = args.idp
        self.sensor_management = args.sensor_management
        self.dspm = args.dspm
        if not args.iam_role_name:
            self.iam_role_name = ""
        else:
          self.iam_role_name = args.iam_role_name
        self.existing_cloudtrail = args.existing_cloudtrail
        if not args.realtime_visibility_regions:
          self.realtime_visibility_regions = "all"
        else:
            self.realtime_visibility_regions = args.realtime_visibility_regions
        if not args.dspm_regions:
            self.dspm_regions = ""
        else:
            self.dspm_regions = args.dspm_regions
        self.ous = args.ous.split(",")

def parse_command_line():
    """Parse command line arguments."""
    parser = ArgumentParser("generate_org_modules.py", add_help=True)
    parser.add_argument(
        "-l",
        "--log-level",
        dest="log_level",
        help="Default log level (DEBUG, WARN, INFO, ERROR)",
        default = "ERROR",
        required=False,
    )
    parser.add_argument(
        "-t",
        "--target-directory",
        dest="target",
        help="Path to directory to save modules",
        default = "fcs-tf-modules",
        required=False,
    )
    parser.add_argument(
        "-c",
        "--config-file",
        dest="config_file",
        help="Path to config.ini file",
        required=False,
    )
    parser.add_argument(
        "-k",
        "--falcon-client-id",
        dest="falcon_client_id",
        help="Your Falcon API Client Id",
        required=False,
    )
    parser.add_argument(
        "-s",
        "--falcon-client-secret",
        dest="falcon_client_secret",
        help="Your Falcon API Client Secret",
        required=False,
    )
    parser.add_argument(
        "-a",
        "--aws-auth-method",
        dest="aws_auth_method",
        help="Auth method for AWS Providers (role, profile)",
        default="role",
        required=False,
    )
    parser.add_argument(
        "-A",
        "--cross-account-role",
        dest="cross_account_role",
        help="If auth-method = role, the name of the cross account IAM Role for AWS",
        required=False,
    )
    parser.add_argument(
        "-p",
        "--primary-region",
        dest="primary_region",
        help="Your AWS Region",
        default="us-east-1",
        required=False,
    )
    parser.add_argument(
        "-b",
        "--permissions-boundary",
        dest="permissions_boundary",
        help="Your AWS IAM Permissions Boundary policy name if required for IAM Role creation",
        required=False,
    )
    parser.add_argument(
        "-r",
        "--realtime-visibility",
        dest="realtime_visibility",
        help="Whether to enable Realtime Visibility (IOA)",
        default = "true",
        required=False,
    )
    parser.add_argument(
        "-i",
        "--idp",
        dest="idp",
        help="Whether to enable Identity Protection",
        default = "true",
        required=False,
    )
    parser.add_argument(
        "-S",
        "--sensor-management",
        dest="sensor_management",
        help="Whether to enable Sensor Management (OneClick)",
        default = "true",
        required=False,
    )
    parser.add_argument(
        "-d",
        "--dspm",
        dest="dspm",
        help="Whether to enable DSPM",
        default = "false",
        required=False,
    )
    parser.add_argument(
        "-C",
        "--custom-role-name",
        dest="iam_role_name",
        help="Set the name of the IAM Role for CSPM, if you require a custom name",
        required=False,
    )
    parser.add_argument(
        "-E",
        "--existing-cloudtrail",
        dest="existing_cloudtrail",
        help="Whether to use existing CloudTrail. Choose false to create a new Organization CloudTrail and enable ReadOnly IOAs",
        default = "true",
        required=False,
    )
    parser.add_argument(
        "-R",
        "--realtime-visibility-regions",
        dest="realtime_visibility_regions",
        help="If realtime_visibility = True, List of Regions to enable for Realtime Visibility",
        default="",
        required=False,
    )
    parser.add_argument(
        "-D",
        "--dspm-regions",
        dest="dspm_regions",
        help="If dspm = True, List of Regions to enable for DSPM",
        required=False,
    )
    parser.add_argument(
        "-o",
        "--target-ous",
        dest="ous",
        help="List of AWS OUs to target.  If blank, modules will be generated for all accounts in the AWS Organization",
        default="",
        required=False,
    )
    return parser.parse_args()

def create_directory(config):
    try:
        os.mkdir(config.target)
        print(f"Directory '{config.target}' created successfully.")
        return
    except FileExistsError:
        print(f"Directory '{config.target}' already exists.")
        return
    except PermissionError:
        print(f"Permission denied: Unable to create '{config.target}'.")
    except Exception as e:
        print(f"An error occurred: {e}")

def get_accounts(config):
    """Get AWS accounts."""
    client = boto3.client('organizations')
    organization = client.describe_organization()
    management_id = organization['Organization']['MasterAccountId']
    org_id = organization['Organization']['Id']
    response_accounts = []
    ou_list = config.ous
    if ou_list != ['']:
        active_accounts = []
        for ou in ou_list:
            response = client.list_accounts_for_parent(ParentId=ou)
            response_accounts += response['Accounts']
            next_token = response.get('NextToken', None)

            while next_token:
                response = client.list_accounts_for_parent(ParentId=ou,NextToken=next_token)
                response_accounts += response['Accounts']
                next_token = response.get('NextToken', None)
        active_accounts += [a for a in response_accounts if a['Status'] == 'ACTIVE']
        mgmt_response = client.describe_account(AccountId=management_id)
        active_accounts.append(mgmt_response['Account'])
    else:
        response = client.list_accounts()
        response_accounts = response['Accounts']
        next_token = response.get('NextToken', None)

        while next_token:
            response = client.list_accounts(NextToken=next_token)
            response_accounts += response['Accounts']
            next_token = response.get('NextToken', None)

        active_accounts = [a for a in response_accounts if a['Status'] == 'ACTIVE']
    return org_id, management_id, active_accounts

def generate_var_file(config):
    content="""variable "falcon_client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client ID"
}
variable "falcon_client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}
variable "aws_auth_method" {
  type        = string
  description = "AWS Provider Authentication Method"
  default     = ""
}
variable "cross_account_role" {
  type        = string
  description = "AWS Organization Cross Account Role"
  default     = ""
}
variable "management_account_id" {
  type        = string
  description = "AWS Organization Management Account Id"
  default     = ""
}
variable "organization_id" {
  type        = string
  description = "AWS Organization Id"
  default     = ""
}
variable "primary_region" {
  type        = string
  description = "AWS Primary Region"
  default     = ""
}
variable "permissions_boundary" {
  type        = string
  description = "AWS IAM Permissions Boundary Policy name"
  default     = ""
}
variable "realtime_visibility" {
  type        = bool
  description = "Enable Realtime Visibility"
  default     = true
}
variable "idp" {
  type        = bool
  description = "Enable Identity Protection"
  default     = true
}
variable "sensor_management" {
  type        = bool
  description = "Enable Sensor Management"
  default     = true
}
variable "dspm" {
  type        = bool
  description = "Enable DSPM"
  default     = false
}
variable "iam_role_name" {
  type        = string
  description = "Custom IAM Role Name"
  default     = ""
}
variable "existing_cloudtrail" {
  type        = bool
  description = "Use Existing CloudTrail"
  default     = true
}
variable "realtime_visibility_regions" {
  type        = list(string)
  description = "The regions in which Realtime Visibility resources will be created"
  default     = ["all"]
}
variable "dspm_regions" {
  type        = list(string)
  description = "The regions in which DSPM scanning environments will be created"
  default     = ["us-east-1"]
}
"""
    f = open(f"{config.target}/variables.tf", "w")
    f.write(content)

    return

def generate_config_file(config, org_id, management_id):
    rtv_regions = config.realtime_visibility_regions
    rtv_regions_list = '['+','.join(['"'+x+'"' for x in rtv_regions.split(',')])+']'
    dspm_regions = config.dspm_regions
    dspm_regions_list = '['+','.join(['"'+x+'"' for x in dspm_regions.split(',')])+']'
    content="""falcon_client_id            = "{falcon_client_id}"
falcon_client_secret        = "{falcon_client_secret}"
aws_auth_method             = "{aws_auth_method}"
cross_account_role          = "{cross_account_role}"
management_account_id       = "{management_account_id}"
organization_id             = "{organization_id}"
primary_region              = "{primary_region}"
permissions_boundary        = "{permissions_boundary}"
realtime_visibility         = {realtime_visibility}
idp                         = {idp}
sensor_management           = {sensor_management}
dspm                        = {dspm}
iam_role_name               = "{iam_role_name}"
existing_cloudtrail         = {existing_cloudtrail}
realtime_visibility_regions = {realtime_visibility_regions}
dspm_regions                = {dspm_regions}\
""".format(falcon_client_id=config.falcon_client_id,
          falcon_client_secret=config.falcon_client_secret,
          aws_auth_method=config.aws_auth_method,
          cross_account_role=config.cross_account_role,
          management_account_id=management_id,
          organization_id=org_id,
          primary_region=config.primary_region,
          permissions_boundary=config.permissions_boundary,
          realtime_visibility=config.realtime_visibility,
          idp=config.idp,
          sensor_management=config.sensor_management,
          dspm=config.dspm,
          iam_role_name=config.iam_role_name,
          existing_cloudtrail=config.existing_cloudtrail,
          realtime_visibility_regions=rtv_regions_list,
          dspm_regions=dspm_regions_list
           )
    f = open(f"{config.target}/config.tfvars", "w")
    f.write(content)

    return

def generate_crowdstrike_module(config):
    content="""terraform {
  required_version = ">= 0.15"
  required_providers {
    crowdstrike = {
      source  = "crowdstrike/crowdstrike"
      version = ">= 0.0.16"
    }
  }
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id                         = var.management_account_id
  organization_id                    = var.organization_id
  is_organization_management_account = true

  asset_inventory = {
    enabled = true
  }

  realtime_visibility = {
    enabled                 = var.realtime_visibility
    cloudtrail_region       = var.primary_region
    use_existing_cloudtrail = var.existing_cloudtrail
  }

  idp = {
    enabled = var.idp
  }

  sensor_management = {
    enabled = var.sensor_management
  }

  dspm = {
    enabled = var.dspm
  }
  provider = crowdstrike
}\
"""
    f = open(f"{config.target}/register-organization.tf", "w")
    f.write(content)

    return

def generate_account_modules_role(config, account_id, management_id):
    mgmt_content="""module "management_account_{account_id}" {{
  source                      = "CrowdStrike/fcs/aws//modules/registration-role"
  account_id                  = "{account_id}"
  cross_account_role_name     = var.cross_account_role
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
  primary_region              = var.primary_region
  enable_sensor_management    = var.sensor_management
  enable_realtime_visibility  = var.realtime_visibility
  enable_idp                  = var.idp
  realtime_visibility_regions = var.realtime_visibility_regions
  use_existing_cloudtrail     = var.existing_cloudtrail 
  enable_dspm                 = var.dspm
  dspm_regions                = var.dspm_regions
  permissions_boundary        = var.permissions_boundary

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {{
    crowdstrike = crowdstrike
  }}
}}\
""".format(account_id=management_id)

    member_content="""module "member_account_{account_id}" {{
  source                      = "CrowdStrike/fcs/aws//modules/registration-role"
  account_id                  = "{account_id}"
  cross_account_role_name     = var.cross_account_role
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
  primary_region              = var.primary_region
  enable_sensor_management    = var.sensor_management
  enable_realtime_visibility  = var.realtime_visibility
  enable_idp                  = var.idp
  realtime_visibility_regions = var.realtime_visibility_regions
  use_existing_cloudtrail     = var.existing_cloudtrail 
  enable_dspm                 = var.dspm
  dspm_regions                = var.dspm_regions
  permissions_boundary        = var.permissions_boundary

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = "" # not needed for child accounts

  providers = {{
    crowdstrike = crowdstrike
  }}
}}\
""".format(account_id=account_id)

    if account_id in management_id:
        f = open(f"{config.target}/mgmt-{account_id}.tf", "w")
        f.write(mgmt_content)
    else:
        f = open(f"{config.target}/{account_id}.tf", "w")
        f.write(member_content)
    
    return

def generate_account_modules_profile(config, account_id, management_id):
    mgmt_content="""module "management_account_{account_id}" {{
  source                      = "CrowdStrike/fcs/aws//modules/registration-profile"
  aws_profile                 = "AWS_PROFILE"
  account_id                  = "{account_id}"
  cross_account_role_name     = var.cross_account_role
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
  primary_region              = var.primary_region
  enable_sensor_management    = var.sensor_management
  enable_realtime_visibility  = var.realtime_visibility
  enable_idp                  = var.idp
  realtime_visibility_regions = var.realtime_visibility_regions
  use_existing_cloudtrail     = var.existing_cloudtrail 
  enable_dspm                 = var.dspm
  dspm_regions                = var.dspm_regions
  permissions_boundary        = var.permissions_boundary

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {{
    crowdstrike = crowdstrike
  }}
}}\
""".format(account_id=management_id)

    member_content="""module "member_account_{account_id}" {{
  source                      = "CrowdStrike/fcs/aws//modules/registration-profile"
  aws_profile                 = "AWS_PROFILE"
  account_id                  = "{account_id}"
  cross_account_role_name     = var.cross_account_role
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
  primary_region              = var.primary_region
  enable_sensor_management    = var.sensor_management
  enable_realtime_visibility  = var.realtime_visibility
  enable_idp                  = var.idp
  realtime_visibility_regions = var.realtime_visibility_regions
  use_existing_cloudtrail     = var.existing_cloudtrail 
  enable_dspm                 = var.dspm
  dspm_regions                = var.dspm_regions
  permissions_boundary        = var.permissions_boundary

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = "" # not needed for child accounts

  providers = {{
    crowdstrike = crowdstrike
  }}
}}\
""".format(account_id=account_id)

    if account_id in management_id:
        f = open(f"{config.target}/mgmt-{account_id}.tf", "w")
        f.write(mgmt_content)
    else:
        f = open(f"{config.target}/{account_id}.tf", "w")
        f.write(member_content)
    
    return

if __name__ == "__main__":
    """Main Function"""
    args = parse_command_line()
    if args.config_file:
        config = FileConfiguration(args.config_file)
    else:
        config = ArgConfiguration(args)
    create_directory(config)
    org_id, management_id, accounts = get_accounts(config)
    generate_var_file(config)
    generate_config_file(config, org_id, management_id)
    generate_crowdstrike_module(config)
    for account in accounts:
        account_id = account['Id']
        if 'role' in config.aws_auth_method:
            generate_account_modules_role(config, account_id, management_id)
        else:
            generate_account_modules_profile(config, account_id, management_id)
    if 'profile' in config.aws_auth_method:
      print('IMPORTANT')
      print('Please update the AWS_PROFILE in each terraform file for each respective account.')