################################################################################
# This file contains network and security resources
################################################################################

# VPC Module which creates a VPC, 2 private subnets(with a single shared NAT gateway) and 2 public subnets
# P.S: I am making use of the AWS community supported VPC module due to time constraint. It is better and safer to create modules for internal use.
module "ecommerce_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.1"

  name               = local.project_name
  azs                = var.azs
  cidr               = var.vpc_cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.common_tags
}

# Security Group for RDS. Allows traffic from NAT instance
resource "aws_security_group" "ecommerce_db_sg" {
  name        = "${local.project_name}-rds-sg"
  vpc_id      = module.ecommerce_vpc.vpc_id
  description = "Manages traffic to the RDS instance"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecommerce_db_nat.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Security Group for NAT instance. "Forwards" traffic to the RDS
resource "aws_security_group" "ecommerce_db_nat" {
  name        = "${local.project_name}-nat-sg"
  description = "Manages traffic to the NAT EC2 instance"
  vpc_id      = module.ecommerce_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.nat_access_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
