output "kms_sns_key_arn" {
  value = module.kms["kms_sns"].key_arn
}

output "s3_bucket_id" {
  value       = module.s3_bucket.s3_bucket_id
  description = "ID of main S3 bucket used by Application"
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.s3_bucket_arn
  description = "ARN of main S3 bucket used by Application"
}

output "ecr_arn" {
  value       = module.ecr.repository_arn
  description = "ARN of Elastic Container Registry but to push images"
}

output "ecr_url" {
  value       = module.ecr.repository_url
  description = "URL of Elastic Container Registry but to push images"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.cluster.arn
  description = "ARN of Elastic Container cluster where fargate services are running."
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "Name of Elastic Container Cluster."
}

output "secret_manager_arn" {
  value       = aws_secretsmanager_secret.app_secrets.arn
  description = "Main ARN of Secret Manager record for secrets."
}

output "secret_manager_name" {
  value       = aws_secretsmanager_secret.app_secrets.name
  description = "Name of Secret Manager record."
}

output "security_group_alb" {
  value       = module.security_group_alb.security_group_arn
  description = "ARN of security group used by the ALB."
}

output "internal_alb" {
  value       = module.internal_alb.lb_arn
  description = "Internal load balancer ARN."
}

output "security_group_rds" {
  value       = module.security_group_rds.security_group_arn
  description = "ARN of security group by the RDS Aurora Postgress database."
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora_db.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora_db.cluster_id
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora_db.cluster_endpoint
}

output "cluster_port" {
  description = "The database port"
  value       = module.aurora_db.cluster_port
}

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.aurora_db.cluster_instances
}

output "sns_topic_arns" {
  value       = tolist([for topic_name, topic in module.sns_topic : topic.topic_arn])
  description = "SNS topics where application will create messages."
}

output "iam_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "ARN of main role used by ECS task service when running the Fargate container."
}

output "security_group_ecs" {
  value       = module.security_group_ecs.security_group_arn
  description = "ARN of security group by the ECS fargate service."
}

output "security_group_ecs_id" {
  value       = module.security_group_ecs.security_group_id
  description = "ID of security group used with ECS Fargate service."
}

output "target_group_alb" {
  value       = aws_lb_target_group.target_group.arn
  description = "ARN of target group used by the listener and ALB for Application."
}

output "kms_key_arns" {
  value = tolist([
    for service, key in module.kms : key.key_arn
  ])
  description = "ARN's of KMS keys generated for each service that will be used encryption at rest."
}

output "kms_s3_arn" {
  value       = module.kms["kms_s3"].key_arn
  description = "ARN's of KMS key used for S3 buckets of Service."
}

# SQS Queue Names
output "sqs_fifo_organizations_name" {
  value       = module.sqs_fifo_organizations.queue_name
  description = "SQS Name used when connecting to Control-center SNS topic."
}

output "sqs_fifo_organizations_dlq_name" {
  value       = module.sqs_fifo_organizations.dead_letter_queue_name
  description = "Dead Letter Queue for SQS used to connect on Control-center SNS topic."
}

output "sqs_fifo_terminals_name" {
  value       = module.sqs_fifo_terminals.queue_name
  description = "Name of SQS queue used for terminals on Control-center."
}

output "sqs_fifo_terminals_dlq_name" {
  value       = module.sqs_fifo_terminals.dead_letter_queue_name
  description = "Dead Letter Queue for SQS used to connect on Control-center SNS topic."
}

output "sqs_fifo_merchants_name" {
  value       = module.sqs_fifo_merchants.queue_name
  description = "Name of SQS queue used for merchants on Control-center."
}

output "sqs_fifo_merchants_dlq_name" {
  value       = module.sqs_fifo_merchants.dead_letter_queue_name
  description = "Dead Letter Queue for SQS used to connect on Control-center SNS topic."
}

output "sqs_fifo_sources_name" {
  value       = module.sqs_fifo_sources.queue_name
  description = "Name of SQS queue used for merchants on Control-center."
}

output "sqs_fifo_sources_dlq_name" {
  value       = module.sqs_fifo_sources.dead_letter_queue_name
  description = "Dead Letter Queue for SQS used to connect on Control-center SNS topic."
}

output "sqs_fifo_terminal-settings_name" {
  value       = module.sqs_fifo_terminal-settings.queue_name
  description = "Name of SQS queue used for terminal-settings on Settings API."
}

output "sqs_fifo_terminal-settings_dlq_name" {
  value       = module.sqs_fifo_terminal-settings.dead_letter_queue_name
  description = "Dead Letter Queue for SQS used to connect on Settings API SNS topic."
}