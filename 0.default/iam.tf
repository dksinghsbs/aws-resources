module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "5.33.1"
}

# Main role to be used by the task running on ECS Fargate service.
resource "aws_iam_role" "iam_role" {
  name        = "${var.service}-task-${var.environment}"
  description = "This role will be used by the task running on ECS service."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "sns_policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSNSRole"
}

resource "aws_iam_role_policy_attachment" "sqs_policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess"
}

data "aws_secretsmanager_secret" "datadog_api_arn" {
  name = "datadog-api-key-plaintext"
}

data "aws_secretsmanager_secret" "dockerhub_api_arn" {
  name = "dockerhub-auth"
}

resource "aws_iam_role_policy_attachment" "custom_policies_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.custom_policies.arn
}

# Custom Policies used by 
resource "aws_iam_policy" "custom_policies" {
  name        = "${var.service}-custom-policies-${var.environment}"
  description = "Custom Policy that grants <Service> access to multiple resources."

  policy = <<EOFX
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "${aws_secretsmanager_secret.settings_api_secrets.arn}",
                "${data.aws_secretsmanager_secret.datadog_api_arn.arn}",
                "${data.aws_secretsmanager_secret.dockerhub_api_arn.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${data.terraform_remote_state.cc-infra.outputs.s3_bucket_arn}",
                "${data.terraform_remote_state.cc-infra.outputs.s3_bucket_arn}/*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeImages"
            ],
            "Resource": [
                "${module.ecr.repository_arn}"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeServices",
                "ecs:UpdateService",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
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
            "Resource": "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:${var.service}-${var.environment}-*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
              "kms:Decrypt",
              "kms:GenerateDataKey*"
            ],
            "Resource": "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${data.terraform_remote_state.cc-infra.outputs.s3_bucket_arn}",
                "${data.terraform_remote_state.cc-infra.outputs.s3_bucket_arn}/*"
            ]
        }
    ]
}
EOFX
}