# This module is creating a Security Group to be used by the Application Load Balancer. 
# The initial ingress is limited to port 443 from private subnets, with open outbound rule.
module "security_group_alb" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${var.service}-alb-${var.environment}"
  description     = "Security group for application load balancer."
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = var.https_port
      to_port     = var.https_port
      protocol    = "tcp"
      description = "Inbound traffic from private subnets."
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks)
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks)
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      description = "Outbound ruke to allow traffic on application port to private subnet."
    },
    {
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks)
      from_port   = var.https_port
      to_port     = var.https_port
      protocol    = "tcp"
      description = "Outbound connectivity to on https port to private subnet."
    }
  ]
}


# Module used to create security group for the RDS database, the initial setup is allowing conections from public/private subnets on database port.
module "security_group_rds" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${var.service}-rds-${var.environment}"
  description     = "Security group for Application Aurora postgresql14 database."
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      description = "Inbound traffic from private subnets."
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks)
    },
    {
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      description = "Inbound traffic from Public subnets."
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks)
    }
  ]

}

# Security group used by the ECS Fargate service .
module "security_group_ecs" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${var.service}-ecs-${var.environment}"
  description     = "Security group for Application fargate ECS."
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      description = "Inbound traffic from private subnets."
      cidr_blocks = join(",", data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks)
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      from_port   = "0"
      to_port     = "65535"
      protocol    = "tcp"
      description = "Outbound connectivity to https port to allow calls to public APIs like AWS ECR."
    }
  ]
}