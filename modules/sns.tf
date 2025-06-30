locals {
  common_tags = {
    Project     = "AFT-Pipeline-Notifications"
    Environment = "prod"
    Owner       = "cloud-platform"
    CostCenter  = "CC1234"
  }
}

module "sns" {
  source      = "./modules/sns_notify"
  topic_name  = "aft-pipeline-topic"
  tags        = local.common_tags
  subscribers = ["secops@example.com", "devops@example.com"]
}
