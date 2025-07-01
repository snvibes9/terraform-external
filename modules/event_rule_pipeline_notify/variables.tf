variable "rule_name" {
  description = "Name of the CloudWatch Event rule"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN to which EventBridge should send notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
