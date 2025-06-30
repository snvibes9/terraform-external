output "event_rule_arn" {
  description = "ARN of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.this.arn
}

output "sns_target_role_arn" {
  description = "IAM role ARN used by EventBridge to publish to SNS"
  value       = aws_iam_role.eventbridge_invoke_sns.arn
}
