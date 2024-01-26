################################################################################
# Cluster
################################################################################
module "ecs_cluster" {
  source       = "terraform-aws-modules/ecs/aws"
  version      = "5.7.4"
  cluster_name = "${var.service}-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 1
      }
    }
  }
  tags = local.tags
}

