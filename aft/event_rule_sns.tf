terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notifications"
    Environment = "Internal"
    CostCenter  = ""
 }
}

variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "aft-pipeline-notification"
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.topic_name))
    error_message = "Topic name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "subscribers" {
  description = "List of email addresses to subscribe to SNS topic"
  type        = list(string)
  default     = ["admin@example.com"]
  validation {
    condition = alltrue([
      for email in var.subscribers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All subscribers must be valid email addresses."
  }
}

variable "rule_name" {
  description = "Name of the CloudWatch Event rule"
  type        = string
  default     = "aft-pipeline-notification-rule"
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.rule_name))
    error_message = "Rule name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

resource "aws_sns_topic" "this" {
  name = var.topic_name

  tags = merge(var.tags, local.common_tags, {
    "Createdby" = "AFT"
  })
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.sns_policy.json
}

data "aws_iam_policy_document" "sns_policy" {
  statement {
    sid    = "AllowEventBridgeToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this.arn]
  }
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.subscribers)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = var.rule_name
  description = "Notify on AFT customization pipeline stage change events"

  event_pattern = jsonencode({
    source        = ["aws.codepipeline"],
    "detail-type" = ["CodePipeline Stage Execution State Change"],
    detail = {
      state    = ["SUCCEEDED", "FAILED"],
      pipeline = [
        "*-account-customization"
      ]
    }
  })

  tags = merge(var.tags, local.common_tags, {
    "Createdby" = "AFT"
  })
}

resource "aws_iam_role" "eventbridge_invoke_sns" {
  name               = "${var.rule_name}-invoke-sns-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_trust.json

  tags = merge(var.tags, local.common_tags, {
    "Createdby" = "AFT"
  })
}

resource "aws_iam_role_policy" "eventbridge_publish_to_sns" {
  name   = "AllowSnsPublish"
  role   = aws_iam_role.eventbridge_invoke_sns.name
  policy = data.aws_iam_policy_document.allow_sns_publish.json
}

data "aws_iam_policy_document" "eventbridge_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "allow_sns_publish" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this.arn]
  }
}

resource "aws_cloudwatch_event_target" "sns_target_with_role" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "aft-pipeline-sns-target"
  arn       = aws_sns_topic.this.arn
  role_arn  = aws_iam_role.eventbridge_invoke_sns.arn
}

output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.this.arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = aws_sns_topic.this.id
}

output "event_rule_arn" {
  description = "ARN of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.this.arn
}

output "event_rule_name" {
  description = "Name of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.this.name
}