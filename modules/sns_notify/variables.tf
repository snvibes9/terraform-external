variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "tags" {
  description = "Tags to apply to SNS topic"
  type        = map(string)
  default     = {}
}

variable "subscribers" {
  description = "List of email addresses to subscribe to SNS topic"
  type        = list(string)
  default     = []
}
