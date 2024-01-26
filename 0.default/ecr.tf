# This module is creating the Elastic Container Registry where Control Center images wil be pushed.
module "ecr" {
  depends_on                      = [module.kms_ecr]
  source                          = "terraform-aws-modules/ecr/aws"
  version                         = "1.6.0"
  repository_name                 = "${var.service}-${var.environment}"
  registry_scan_type              = "ENHANCED"
  repository_encryption_type      = "KMS"
  repository_kms_key              = module.kms_ecr.key_arn
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}