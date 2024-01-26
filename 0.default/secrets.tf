resource "random_password" "rds_passwords" {
  count            = 2
  length           = 32
  special          = false
  override_special = "/'\"@"
}

resource "random_string" "random_suffix" {
  count   = 2
  length  = 7
  special = false
  upper   = false
  numeric = false
}

# Secret Manager entry for the database details related to Control Center.
resource "aws_secretsmanager_secret" "app_secrets" {
  depends_on  = [module.kms]
  name        = "${var.service}-${var.environment}"
  description = "Secrets for application."
  kms_key_id  = module.kms["kms_secrets"].key_id
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    "db_user"            = "app${random_string.random_suffix[0].result}"
    "db_password"        = random_password.rds_passwords[0].result
    "db_master"          = "master${random_string.random_suffix[1].result}"
    "db_password_master" = random_password.rds_passwords[1].result
  })
}