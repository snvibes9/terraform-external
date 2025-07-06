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
  region = var.aws_region
  
  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notifications"
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
  }
}

module "sns" {
  source      = "./modules/sns_topic"
  topic_name  = var.sns_topic_name
  tags        = local.common_tags
  subscribers = var.email_subscribers
}

module "event_rule" {
  source        = "./modules/event_rule_pipeline_notify"
  rule_name     = var.event_rule_name
  sns_topic_arn = module.sns.sns_topic_arn
  tags          = local.common_tags
}