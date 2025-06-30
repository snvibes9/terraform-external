resource "aws_cloudwatch_event_rule" "this" {
  name        = var.rule_name
  description = "Notify on AFT customization pipeline stage change events"
  
  event_pattern = jsonencode({
    source        = ["aws.codepipeline"],
    "detail-type" = ["CodePipeline Stage Execution State Change"],
    resource      = var.pipeline_arns,
    detail = {
      state = ["SUCCEEDED", "FAILED"]
    }
  })

  tags = merge(var.tags, {
    "SecurityLevel" = "Hardened-Level-1"
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "aft-pipeline-sns"
  arn       = var.sns_topic_arn
}

resource "aws_iam_role" "eventbridge_invoke_sns" {
  name = "${var.rule_name}-invoke-sns-role"

  assume_role_policy = data.aws_iam_policy_document.eventbridge_trust.json

  inline_policy {
    name   = "AllowSnsPublish"
    policy = data.aws_iam_policy_document.allow_sns_publish.json
  }

  tags = merge(var.tags, {
    "SecurityLevel" = "Hardened-Level-1"
  })
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
    resources = [var.sns_topic_arn]
  }
}

resource "aws_cloudwatch_event_target" "sns_target_with_role" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "aft-pipeline-sns-role"
  arn       = var.sns_topic_arn
  role_arn  = aws_iam_role.eventbridge_invoke_sns.arn
}
