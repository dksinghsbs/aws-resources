#Module that creates Customer Managed Keys that are designated for each AWS resources that use encryption at rest.
module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "2.1.0"
  for_each                = var.kms_service_keys
  description             = "KMS key used by ${each.value} resources within application."
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  multi_region            = true
  enable_default_policy   = true
  aliases_use_name_prefix = false
  aliases                 = ["${var.service}-${each.value}-${var.environment}"]
}