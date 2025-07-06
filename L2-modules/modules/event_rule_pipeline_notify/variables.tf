variable "rule_name" {
  description = "Name of the CloudWatch Event rule"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.rule_name))
    error_message = "Rule name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN to which EventBridge should send notifications"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.sns_topic_arn))
    error_message = "SNS Topic ARN must be a valid AWS SNS ARN."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}