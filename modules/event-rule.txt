locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notify"
    Environment = "prod"
    Owner       = "cloud-platform"
    CostCenter  = "CC1234"
  }
}

module "event_rule" {
  source        = "./modules/event_rule_pipeline_notify"
  rule_name     = "aft-pipeline-notify-rule"
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:aft-pipeline-topic"

  pipeline_arns = [
    "arn:aws:codepipeline:us-east-1:111122223333:customizations-account-1111",
    "arn:aws:codepipeline:us-east-1:222233334444:customizations-account-2222"
  ]

  tags = local.common_tags
}
