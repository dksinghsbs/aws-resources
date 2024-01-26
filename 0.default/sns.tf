# This module creates multiple topics for Application to be able to produce messages that will be later consumed.
module "sns_topic" {
  depends_on = [module.kms]
  source     = "terraform-aws-modules/sns/aws"
  version    = "6.0.0"
  for_each   = var.sns_topics
  
  name                        = "${var.service}-${var.environment}-${each.value}.fifo"
  display_name                = "${var.service}-${var.environment}-${each.value}"
  fifo_topic                  = true
  content_based_deduplication = true
  enable_default_topic_policy = true
  use_name_prefix             = false
  kms_master_key_id           = module.kms["kms_sns"].key_id
  create_topic_policy         = false
}

resource "aws_sns_topic_policy" "default" {
  for_each = var.sns_topics
  arn    = module.sns_topic[each.key].topic_arn
  policy = <<EOFX
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [ 
          "ecs-tasks.amazonaws.com",
          "sqs.amazonaws.com"
        ]
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:ap-south-1:${data.aws_caller_identity.current.account_id}:${var.service}-${var.environment}-${each.value}.fifo",
      "Condition": {
        "ArnEquals": {
          "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}
EOFX
}