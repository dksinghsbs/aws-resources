#Datasource
data "aws_secretsmanager_secret" "redis-token" {
  arn = module.redis_authentication_token.arn
  depends_on = [
    module.redis_authentication_token
  ]
}

data "aws_secretsmanager_secret_version" "secret_redis_token" {
  secret_id = data.aws_secretsmanager_secret.redis-token.id
  depends_on = [
    data.aws_secretsmanager_secret.redis-token
  ]
}

# Redis subnetgroup that will be used with the redis cluster.
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = "${var.service}-${var.environment}"
  subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  description = "Private subnets used by Presence redis cluster"
  #tags        = local.tags
}

# Redis Cluster to be used with <Service>
resource "aws_elasticache_replication_group" "presence" {
  depends_on                  = [aws_security_group.redis]
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  replication_group_id        = "${var.service}-${var.environment}"
  description                 = "Redis cluster for App/service redis cache"
  node_type                   = var.node_type
  num_cache_clusters          = 3
  parameter_group_name        = "default.redis7"
  port                        = var.redis_port
  at_rest_encryption_enabled  = true
  transit_encryption_enabled  = true
  multi_az_enabled            = true
  auth_token                  = data.aws_secretsmanager_secret_version.secret_redis_token.secret_string
  maintenance_window          = "mon:08:00-mon:09:00"
  snapshot_window             = "12:00-13:00"
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids          = [aws_security_group.redis.id]
  tags                        = local.tags
  apply_immediately           = true
}