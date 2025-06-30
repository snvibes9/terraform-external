variable "rule_name" {
  description = "Name of the CloudWatch Event rule"
  type        = string
}

variable "pipeline_arns" {
  description = "List of AFT CodePipeline ARNs to monitor"
  type        = list(string)
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to publish notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
