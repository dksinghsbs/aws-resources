# Application Load Balancer to be used by <service> to receive requests.
module "alb" {
  depends_on                 = [module.security_group_alb]
  source                     = "terraform-aws-modules/alb/aws"
  version                    = "9.4.1"
  name                       = "${var.service}-${var.environment}"
  load_balancer_type         = "application"
  internal                   = true
  create_security_group      = false
  drop_invalid_header_fields = true
  vpc_id                     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets                    = data.terraform_remote_state.vpc.outputs.private_subnets
  security_groups            = [module.security_group_alb.security_group_id]
}

# Target Group used with the Application load balancer.
resource "aws_lb_target_group" "target_group" {
  name        = "${var.service}-${var.environment}"
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    timeout             = 20
    interval            = 30
    path                = "/manage/info"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    port                = var.health_port
  }
}

# LB Listener
resource "aws_lb_listener" "internal" {
  depends_on        = [module.alb]
  load_balancer_arn = module.alb.lb_arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_alb
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}