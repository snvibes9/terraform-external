output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.sns.sns_topic_arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = module.sns.sns_topic_name
}

output "event_rule_arn" {
  description = "ARN of the CloudWatch Event rule"
  value       = module.event_rule.event_rule_arn
}

output "event_rule_name" {
  description = "Name of the CloudWatch Event rule"
  value       = module.event_rule.event_rule_name
}

output "sns_target_role_arn" {
  description = "IAM role ARN used by EventBridge to publish to SNS"
  value       = module.event_rule.sns_target_role_arn
}
