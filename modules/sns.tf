terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43" # Use a stable recent version that passes security checks
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region                  = "us-east-1"
}

locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notifications"
    Environment = "prod"
    CostCenter  = ""
  }
}

module "sns" {
  source      = "../modules/sns_notify"
  topic_name  = "aft-pipeline-topic"
  tags        = local.common_tags
  subscribers = ["snvibes9@gmail.com"]
}

module "event_rule" {
  source        = "../modules/event_rule_pipeline_notify"
  rule_name     = "aft-pipeline-notify-rule"
  sns_topic_arn = "arn:aws:sns:us-east-1:682475224788:aft-pipeline-topic"
  tags = local.common_tags
}
