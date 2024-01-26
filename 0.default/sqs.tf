module "sqs_fifo" {
  depends_on = [module.kms]
  source     = "git@github.com:PaymentFusion/co-module-terraform-aws-sqs.git?ref=v1.0.0"

  #  # `.fifo` is automatically appended to the name
  #  # This also means that `use_name_prefix` cannot be used on FIFO queues
  for_each   = var.sqs_names
  
  name = "${var.service}-${var.environment}-${each.value}"

  fifo_queue                  = true
  sqs_managed_sse_enabled     = true
  content_based_deduplication = true

  kms_master_key_id = module.kms["kms_sqs"].key_id

  # Dead letter queue
  create_dlq = true
  redrive_policy = {
    #    # default is 5 for this module
    maxReceiveCount = 10
  }
}

resource "aws_sns_topic_subscription" "sns_organizations_subscription" {
  #sns_organizations (Value taken from co-infra-control-center-service from sns_topic variable)
  protocol             = "sqs"
  topic_arn            = data.terraform_remote_state.cc-infra.outputs.sns_topic_arns[1] ## Need to change as per data#
  raw_message_delivery = false
  endpoint             = module.sqs_fifo["organizations"].queue_arn
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.sqs_fifo["organizations"].dead_letter_queue_arn
  })
}
