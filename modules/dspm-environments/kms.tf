data "aws_caller_identity" "current" {}

data "aws_iam_role" "crowdstrike_aws_integration_role" {
  name = var.dspm_role_name
}
data "aws_iam_role" "crowdstrike_aws_scanner_role" {
  name = var.dspm_scanner_role_name
}


data "aws_iam_policy_document" "policy_kms_key" {
  #checkov:skip=CKV_AWS_356:Root user requires unrestricted KMS access according to AWS documentation https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html
  #checkov:skip=CKV_AWS_109,CKV_AWS_111:DSPM roles require permissions to write and modify KMS resources
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":root"])]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow administration of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:userId"
      values = [
        data.aws_iam_role.crowdstrike_aws_integration_role.unique_id,
        "${data.aws_iam_role.crowdstrike_aws_integration_role.unique_id}:*",
      ]
    }
  }
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:userId"
      values = [
        data.aws_iam_role.crowdstrike_aws_integration_role.unique_id,
        "${data.aws_iam_role.crowdstrike_aws_integration_role.unique_id}:*",
        data.aws_iam_role.crowdstrike_aws_scanner_role.unique_id,
        "${data.aws_iam_role.crowdstrike_aws_scanner_role.unique_id}:*"
      ]
    }
  }

}

resource "aws_kms_key" "crowdstrike_kms_key" {
  description              = "CrowdStrike DSPM KMS Key"
  enable_key_rotation      = true
  deletion_window_in_days  = 20
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"
  policy                   = data.aws_iam_policy_document.policy_kms_key.json

  tags = {
    (local.logical_tag_key)     = local.logical_kms_key
    (local.crowdstrike_tag_key) = (local.crowdstrike_tag_value)
  }
}

resource "aws_kms_alias" "crowdstrike_key_alias" {
  name          = "alias/CrowdStrikeDSPMKey"
  target_key_id = aws_kms_key.crowdstrike_kms_key.arn
}
