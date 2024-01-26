locals {
  tags = {
    service                = var.service
    environment            = var.environment
    owner                  = var.owner
    infrastructure_version = var.infrastructure_version
  }
}