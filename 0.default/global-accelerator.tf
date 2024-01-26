resource "aws_globalaccelerator_accelerator" "accelerator" {
  name            = "${var.service}-${var.environment}-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.accelerator.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_listener" "listener_manage" {
  accelerator_arn = aws_globalaccelerator_accelerator.accelerator.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 8081
    to_port   = 8081
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb" {
  listener_arn      = aws_globalaccelerator_listener.listener.id
  health_check_port = 443
  endpoint_configuration {
    endpoint_id = aws_lb.alb.arn
    weight      = 100
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb_manage" {
  listener_arn      = aws_globalaccelerator_listener.listener_manage.id
  health_check_port = 8081
  endpoint_configuration {
    endpoint_id = aws_lb.alb.arn
    weight      = 100
  }
}