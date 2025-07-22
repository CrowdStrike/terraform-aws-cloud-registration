locals {
  target_id = "CrowdStrikeCentralizeEvents"
  rule_name = "cs-cloudtrail-events-ioa-rule"
  event_pattern = jsonencode({
    source = [
      {
        "prefix" : "aws."
      }
    ],
    detail-type = [
      {
        suffix = "via CloudTrail"
      }
    ],
    detail = {
      "eventName" : [
        {
          "anything-but" : [
            "InvokeExecution",
            "Invoke",
            "UploadPart",
            "PutObject",
            "InitiateReplication",
            "Publish"
          ]
        }
      ],
      "readOnly" : [
        false
      ]
    }
  })

  ro_rule_name = "cs-cloudtrail-events-readonly-rule"
  ro_event_pattern = jsonencode({
    source = [
      {
        "prefix" : "aws."
      }
    ],
    detail-type = [
      {
        "suffix" : "via CloudTrail"
      }
    ],
    detail = {
      "readOnly" : [
        true
      ]
    },
    "$or" : [
      {
        "detail" : {
          "eventName" : [
            {
              "anything-but" : [
                "Encrypt",
                "Decrypt",
                "GenerateDataKey",
                "Sign",
                "GetObject",
                "HeadObject",
                "ListObjects",
                "GetObjectTagging",
                "GetObjectAcl",
                "AssumeRole"
              ]
            }
          ]
        }
      },
      {
        "detail" : {
          "eventName" : [
            "AssumeRole"
          ],
          "userIdentity" : {
            "type" : [
              {
                "anything-but" : [
                  "AWSService"
                ]
              }
            ]
          }
        }
      }
    ]
  })

  default_eventbus_arn = "arn:aws:events:${var.primary_region}:${local.account_id}:event-bus/default"
  eventbus_arn = (
    var.is_gov_commercial ?
    (
      var.is_primary_region ?
      aws_lambda_function.eventbridge[0].arn :
      local.default_eventbus_arn
    ) :
    var.eventbus_arn
  )
  eventbridge_role_arn = (
    var.is_gov_commercial && var.is_primary_region ?
    null :
    "arn:${local.aws_partition}:iam::${local.account_id}:role/${var.eventbridge_role_name}"
  )
}

resource "aws_cloudwatch_event_rule" "rw" {
  count         = var.create_rules ? 1 : 0
  name          = local.rule_name
  event_pattern = local.event_pattern
}

resource "aws_cloudwatch_event_target" "rw" {
  count     = var.create_rules ? 1 : 0
  target_id = local.target_id
  arn       = local.eventbus_arn
  rule      = aws_cloudwatch_event_rule.rw[0].name
  role_arn  = local.eventbridge_role_arn

  depends_on = [
    aws_lambda_alias.eventbridge
  ]
}


resource "aws_cloudwatch_event_rule" "ro" {
  count         = var.create_rules ? 1 : 0
  name          = local.ro_rule_name
  event_pattern = local.ro_event_pattern
}

resource "aws_cloudwatch_event_target" "ro" {
  count     = var.create_rules ? 1 : 0
  target_id = local.target_id
  arn       = local.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ro[0].name
  role_arn  = local.eventbridge_role_arn

  depends_on = [
    aws_lambda_alias.eventbridge
  ]
}
