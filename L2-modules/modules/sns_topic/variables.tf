variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.topic_name))
    error_message = "Topic name must contain only alphanumeric characters, hyphens, and underscores."
  }
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
  validation {
    condition = alltrue([
      for email in var.subscribers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All subscribers must be valid email addresses."
  }
}