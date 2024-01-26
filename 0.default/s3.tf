# Module used to create S3 bucket for Application.
module "s3_bucket" {
  depends_on = [module.kms]
  source     = "terraform-aws-modules/s3-bucket/aws"
  version    = "4.1.0"
  bucket     = "${var.service}-${var.environment}"

  control_object_ownership = false

  force_destroy = false

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms["kms_s3"].key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

# # Module used to create S3 bucket for Application. This bucket will be used only by Cloudfront and the UI frontend application.
# module "s3_bucket_cloudfront" {
#   depends_on = [module.kms["kms_s3"]]
#   source     = "git@github.com:PaymentFusion/co-module-terraform-aws-s3-bucket.git?ref=v1.0.0"
#   bucket     = "${var.service}-cloudfront-${var.environment}"

#   control_object_ownership = false

#   force_destroy = false

#   # CDN bucket, objects may be public !
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
#   attach_policy           = true

#   versioning = {
#     enabled = true
#   }

#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         kms_master_key_id = module.kms["kms_s3"].key_id
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }

#   policy = <<EOFCB
#  {
#   "Version": "2008-10-17",
#   "Id": "PolicyForCloudFrontPrivateContent",
#     "Statement": [
#       {
#         "Sid": "AllowCloudFrontServicePrincipal",
#         "Effect": "Allow",
#         "Principal": {
#           "Service": "cloudfront.amazonaws.com"
#         },
#         "Action": "s3:GetObject",
#         "Resource": "${module.s3_bucket_cloudfront.s3_bucket_arn}/*",
#         "Condition": {
#         "StringEquals": {
#           "AWS:SourceArn": "${module.cdn.cloudfront_distribution_arn}"
#         }
#       }
#     }
#   ]
#   }
# EOFCB
# }