resource "aws_sns_topic" "this" {
  name = var.topic_name

  tags = merge(var.tags, {
    "SecurityLevel" = "Hardened-Level-1"
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
