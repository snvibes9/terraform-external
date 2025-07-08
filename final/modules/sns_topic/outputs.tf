output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.this.arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = aws_sns_topic.this.id
}

output "sns_topic_id" {
  description = "ID of the created SNS topic"
  value       = aws_sns_topic.this.id
}