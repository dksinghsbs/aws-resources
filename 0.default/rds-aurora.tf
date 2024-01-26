################################################################################
# RDS Aurora Module
################################################################################

module "aurora_db" {
  depends_on                  = [aws_secretsmanager_secret.app_secrets]
  source                      = "terraform-aws-modules/rds-aurora/aws"
  version                     = "9.0.0"
  name                        = "${var.service}-${var.environment}"
  engine                      = "aurora-postgresql"
  engine_version              = "14.7"
  master_username             = "master${random_string.random_suffix[1].result}"
  master_password             = random_password.rds_passwords[1].result
  manage_master_user_password = false
  auto_minor_version_upgrade  = false
  storage_type                = "aurora-iopt1"

  instances = var.instances

  performance_insights_enabled    = true
  kms_key_id                      = module.kms["kms_rds"].key_arn
  performance_insights_kms_key_id = module.kms["kms_rds"].key_arn

  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  db_subnet_group_name   = "${var.organization}-${var.environment}"
  vpc_security_group_ids = [module.security_group_rds.security_group_id]
  availability_zones     = data.terraform_remote_state.vpc.outputs.azs
  ca_cert_identifier     = var.ca_cert_identifier
  apply_immediately      = true
  skip_final_snapshot    = true


  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "${var.service}-cluster-aurora-postgresqlq14-${var.environment}"
  db_cluster_parameter_group_family      = "aurora-postgresql14"
  db_cluster_parameter_group_description = "${var.service}-cluster-aurora-postgresqlq14-${var.environment}-parameter-group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "log_min_duration_statement"
      value        = 1000
      apply_method = "immediate"
    },
    {
      name         = "rds.force_ssl"
      value        = 1
      apply_method = "immediate"
    },
    {
      name  = "log_statement"
      value = "ddl"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "${var.service}-aurora-postgresql14${var.environment}"
  db_parameter_group_family      = "aurora-postgresql14"
  db_parameter_group_description = "${var.service}-aurora-postgresql14-${var.environment}-parameter-group"
  db_parameter_group_parameters = [
    {
      name         = "log_min_duration_statement"
      value        = 1000
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["postgresql"]
  create_cloudwatch_log_group     = true

  backup_retention_period      = 7
  deletion_protection          = true
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "Mon:00:00-Mon:03:00"
}