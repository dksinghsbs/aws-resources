data "aws_route53_zone" "zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "internal" {
  zone_id = data.aws_route53_zone.zone.id
  name    = var.internal_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}