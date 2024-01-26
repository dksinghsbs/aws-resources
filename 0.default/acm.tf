module "acm" {
  source                 = "terraform-aws-modules/acm/aws"
  version                = "5.0.0"
  hosted_zone_name       = var.hosted_zone_name
  service                = var.service
  environment            = var.environment
  owner                  = var.owner
  infrastructure_version = var.infrastructure_version
  domain_name            = "${var.internal_domain_name}.${var.hosted_zone_name}"
}