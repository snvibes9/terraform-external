variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "cost_center" {
  description = "Cost center for resource billing"
  type        = string
  default     = ""
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "aft-pipeline-topic"
}

variable "event_rule_name" {
  description = "Name of the CloudWatch Event rule"
  type        = string
  default     = "aft-pipeline-notify-rule"
}

variable "email_subscribers" {
  description = "List of email addresses to subscribe to SNS topic"
  type        = list(string)
  default     = []
}