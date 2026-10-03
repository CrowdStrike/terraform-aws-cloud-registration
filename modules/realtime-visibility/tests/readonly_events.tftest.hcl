# Mock providers require Terraform >= 1.7; no AWS or Falcon credentials are used.
mock_provider "aws" {
  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }
}

mock_provider "random" {}

variables {
  region               = "us-east-1"
  primary_region       = "us-east-1"
  account_id           = "111111111111"
  eventbus_arn         = "arn:aws:events:us-east-1:222222222222:event-bus/example"
  falcon_client_id     = "test-client"
  falcon_client_secret = "test-secret"
}

run "readonly_management_events" {
  command = plan

  assert {
    condition     = aws_cloudwatch_event_rule.ro[0].state == "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"
    error_message = "The read-only rule must opt in to CloudTrail read-only management events."
  }

  assert {
    condition = (
      jsondecode(aws_cloudwatch_event_rule.ro[0].event_pattern).detail.readOnly == [true] &&
      jsondecode(aws_cloudwatch_event_rule.rw[0].event_pattern).detail.readOnly == [false]
    )
    error_message = "Keep the existing read/write event filters."
  }

  assert {
    condition = (
      aws_cloudwatch_event_target.ro[0].rule == aws_cloudwatch_event_rule.ro[0].name &&
      aws_cloudwatch_event_target.ro[0].arn == var.eventbus_arn &&
      aws_cloudwatch_event_target.ro[0].target_id == "CrowdStrikeCentralizeEvents"
    )
    error_message = "Keep forwarding read-only events to the existing destination."
  }
}

run "rules_disabled" {
  command = plan
  variables {
    create_rules = false
  }
  assert {
    condition = (
      length(aws_cloudwatch_event_rule.ro) == 0 && length(aws_cloudwatch_event_rule.rw) == 0 &&
      length(aws_cloudwatch_event_target.ro) == 0 && length(aws_cloudwatch_event_target.rw) == 0
    )
    error_message = "Disabling rule creation must still suppress both rules and targets."
  }
}

run "s3_ingestion" {
  command = plan
  variables {
    log_ingestion_method = "s3"
  }
  assert {
    condition = (
      length(aws_cloudwatch_event_rule.ro) == 0 && length(aws_cloudwatch_event_rule.rw) == 0 &&
      length(aws_cloudwatch_event_target.ro) == 0 && length(aws_cloudwatch_event_target.rw) == 0
    )
    error_message = "S3 ingestion must not create EventBridge rules or targets."
  }
}
