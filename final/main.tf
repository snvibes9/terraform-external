terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notifications"
    Environment = "Internal"
    CostCenter  = ""
    ManagedBy   = "terraform"
  }
}

module "sns" {
  source      = "./modules/sns_topic"
  topic_name  = "aft-pipeline-notification"
  tags        = local.common_tags
  subscribers = ["admin@example.com"]
}

module "event_rule" {
  source        = "./modules/event_rule_pipeline_notify"
  rule_name     = "aft-pipeline-notification-rule"
  sns_topic_arn = module.sns.sns_topic_arn
  tags          = local.common_tags
}