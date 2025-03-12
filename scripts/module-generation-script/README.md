![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png#gh-light-mode-only)
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo-red.png#gh-dark-mode-only)

# CrowdStrike Terraform Module Generator for AWS Organizations

Generate the Terraform files and modules necessary to register and onboard an AWS Organization with CrowdStrike FCS.

+ [Overview](#overview-)
+ [Usage](#usage-)
+ [Generated Files](#generated-files-)
+ [Contribute](#contribute-)


## Overview

Terraform modules are designed to be called per provider configuration.  This can make running a module, such as the CrowdStrike Registration terraform module, against many AWS accounts tedious and difficult.  This solution uses Python to generate the modules and other files necessary to use the CrowdStrike Registration terraform module against many or all accounts in your AWS Organization.

## Usage

This soution accepts either a config file or command line arguments.  See examples below:

### Config file

```
python3 generate_org_modules.py -c config.ini
```

Config file example

```
# Leave value blank if not required for your configuration
# Do not use quotes

[target]
TargetDirectory = ./fcs-tf-modules

[aws.auth]
AuthMethod = role
CrossAccountRole = myCrossAccountRole
# Eg. role, profile
# Note: if you choose role, you must include a value for CrossAccountRole
# Note: if you choose profile, you must update the Profile for each account module after running this generation script.

[aws.config]
PrimaryRegion       = us-east-1
PermissionsBoundary = 

[falcon.credentials]
ClientId     = myFalconAPIClientId
ClientSecret = myFalconAPIClientSecret

[falcon.features]
RealtimeVisibility = true
IDP                = true
SensorManagement   = true
DSPM               = false

[asset.inventory]
IAMRoleName = myCustomIAMRoleName

[realtime.visibility]
ExistingCloudTrail = true
Regions            = [all]
# Eg. [us-east-1,us-east-2,us-west-1,us-west-2,af-south-1,ap-east-1,ap-south-1,ap-south-2,ap-southeast-1,ap-southeast-2,ap-southeast-3,ap-southeast-4,ap-northeast-1,ap-northeast-2,ap-northeast-3,ca-central-1,eu-central-1,eu-west-1,eu-west-2,eu-west-3,eu-south-1,eu-south-2,eu-north-1,eu-central-2,me-south-1,me-central-1,sa-east-1]

[dspm]
DSPMRegions = []
# Eg. [us-east-1,us-east-2,us-west-1,us-west-2,af-south-1,ap-east-1,ap-south-1,ap-south-2,ap-southeast-1,ap-southeast-2,ap-southeast-3,ap-southeast-4,ap-northeast-1,ap-northeast-2,ap-northeast-3,ca-central-1,eu-central-1,eu-west-1,eu-west-2,eu-west-3,eu-south-1,eu-south-2,eu-north-1,eu-central-2,me-south-1,me-central-1,sa-east-1]

```

### Command Line Arguments
Available Arguments

```
-c --config-file 
-t --target-directory
-k --falcon-client-id
-s --falcon-client-secret
-a --aws-auth-method
-A --cross-account-role
-p --primary-region
-b --permissions-boundary
-r --realtime-visibility
-i --idp
-S --sensor-management
-d --dspm
-C --custom-role-name
-E --existing-cloudtrail
-R --realtime-visibility-regions
-D --dspm-regions
```

Command Line Arguments Example

```
python3 generate_org_modules.py \
--target-directory ./fcs-tf-modules \
--falcon-client-id myFalconAPIClientId \
--falcon-client-secret myFalconAPIClientSecret \
--aws-auth-method role \
--cross-account-role myCrossAccountRole \
--primary-region us-east-1 \
--realtime-visibility true \
--idp true \
--sensor-management true \
--dspm false \
--custom-role-name myCustomIAMRoleName \
--existing-cloudtrail true \
--realtime-visibility-regions us-east-1,us-east-2
```

## Generated Files
The terraform files will be generated in your target directory.  A successful generation will result in the following files:

- **variables.tf**: Variables required for all modules.
- **config.tfvars**: TFVars file with variable values set based on your input to the script.  Changes made to your configuration (such as enabling or disabling a feature) should be made in this file and will apply to all accounts.
- **register-organization.tf**: Contains provider and resource to register your AWS Organization with CrowdStrike FCS.  This resource returns the configuration values required to onboard the AWS accounts.
- **mgmt-{account_id}.tf**: This file calls the module to onboard your AWS Organization Management account.
- **{account_id}.tf**: In a typical deployment there will be one of these files for each member account of your org.  Each file calls the module to onboard the respective AWS Member Account.
