variable "access_logs_bucket" {
  description = "S3 bucket for load balancer logs"
}

variable "prefix" {
  description = "S3 prefix for load balancer logs"
}

variable "access_logs_enabled" {
  description = "Enable or disable access logs"
  default     = false
}

variable "dockerhub_token" {
  description = "ARN of the AWS secret for the dockerhub token"
}

variable "environment" {
  description = "Environment being deployed"
}

variable "service" {
  description = "Name of the service"
}

variable "owner" {
  description = "Name of who owns the project"
}

variable "infrastructure_version" {
  description = "Used in tags to track infrastructure versions"
}

variable "region" {
  description = "Region where service is being deployed"
}

variable "github_repository_name" {
  description = "GitHub Repository name used in tag"
}

variable "https_port" {
  description = "Control Center HTTPS/SSL port to be used."
  default     = "443"
}

variable "http_port" {
  description = "Port used for HTTP traffic."
  default     = "8080"
}

variable "app_port" {
  description = "Control Center application port."
  default     = "8081"
}

variable "kms_service_keys" {
  description = "This variable holds the values for each KMS key that will be used in KMS module to generate for each service that can encrypt at rest."
  type        = map(string)
  default = {
    kms_ecr     = "ecr"
    kms_sns     = "sns"
    kms_sqs     = "sqs"
    kms_rds     = "rds"
    kms_secrets = "secrets"
    kms_s3      = "s3"
  }
}

variable "certificate_alb" {
  description = "Certificate used by the ALB listeners."
}

variable "sns_topics" {
  description = "This variable holds the name suffix for the SNS topics for Control Center, if new topics just add new key/value in the variable."
  type        = map(string)
  default = {
    topic1 = "topic_1"
    topic2 = "topic_2"
  }
}

variable "db_port" {
  description = "Application Database port"
  default     = "5432"
}

#WAF
variable "waf_regional_ipset" {
  description = "ARN for regional ip set created by infra, under co-infra-waf stack."
}

variable "instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

variable "ca_cert_identifier" {
  default     = "rds-ca-rsa2048-g1"
  description = "Allows you to modify the underlying RDS certificate"
}

variable "hosted_zone_name" {
  description = "Route 53 Hosted Zone name"
}

variable "internal_domain_name" {
  description = "Route 53 Internal Host name"
}

variable "datadog_api_arn" {
  description = "Datadog API Arn"
}

variable "role_suffix" {
  description = "Name of role suffix"
  default     = "role"
}


variable "retention_days" {
  description = "Number of days to keep the ECR images"
  default     = "14"
}

variable "retention_images" {
  description = "Number of images to keep in the ECR repository"
  default     = "30"
}

# Redis cluster variables.
variable "redis_port" {
  description = "Redis port"
  default     = 6379
}

variable "node_type" {
  description = "Redis instances type used in the cluster."
  default     = "cache.m6g.large"
}