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
            "UploadPart"
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
                "GetObject",
                "Encrypt",
                "Decrypt",
                "HeadObject",
                "ListObjects",
                "GenerateDataKey",
                "Sign",
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
}

resource "aws_cloudwatch_event_rule" "rw" {
  name          = local.rule_name
  event_pattern = local.event_pattern
}

resource "aws_cloudwatch_event_target" "rw" {
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.rw.name
  role_arn  = var.eventbridge_role_arn
}


resource "aws_cloudwatch_event_rule" "ro" {
  name          = local.ro_rule_name
  event_pattern = local.ro_event_pattern
}

resource "aws_cloudwatch_event_target" "ro" {
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ro.name
  role_arn  = var.eventbridge_role_arn
}
