# FCS single account registration

This example shows how to provision a single AWS account into Falcon Cloud Security using an `awscli` profile

## Pre-requisites:

Ensure that you have the following tools installed locally:

1. [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

See [Pre-requisites](../../README.md#pre-requisites) for instructions on how to generate your falcon_client_id and falcon_client_secret.

## Deploy

To provision this example:

Set the following environment variables:

```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
```

Run the following commands:

```sh
terraform init
terraform apply
```

Enter `yes` at command prompt to apply


## Destroy

To teardown and remove the resources created in this example:

```sh
terraform destroy -auto-approve
```

