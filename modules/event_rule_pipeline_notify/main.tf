# CloudWatch EventBridge Rule

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

  tags = merge(var.tags, {
    "Createdby"     = "terraform",
  })
}

# IAM Role for EventBridge to Publish to SNS

resource "aws_iam_role" "eventbridge_invoke_sns" {
  name               = "${var.rule_name}-invoke-sns-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_trust.json

  tags = merge(var.tags, {
    "Createdby"     = "terraform",
  })
}

# Policy block
resource "aws_iam_role_policy" "eventbridge_publish_to_sns" {
  name   = "AllowSnsPublish"
  role   = aws_iam_role.eventbridge_invoke_sns.name
  policy = data.aws_iam_policy_document.allow_sns_publish.json
}

# Trust policy to allow events.amazonaws.com to assume the role
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

# Allow the role to publish to the specified SNS topic
data "aws_iam_policy_document" "allow_sns_publish" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [var.sns_topic_arn]
  }
}

# EventBridge Target with Role

resource "aws_cloudwatch_event_target" "sns_target_with_role" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "aft-pipeline-sns-target"
  arn       = var.sns_topic_arn
  role_arn  = aws_iam_role.eventbridge_invoke_sns.arn
}
