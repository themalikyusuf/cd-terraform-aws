################################################################################
# Local values and Data sources
################################################################################

locals {
  project_name = "ecommerce-project"
  common_tags = {
    Name        = local.project_name
    Environment = "production"
    Terraform   = true
  }
}

# Ubuntu AMI for NAT EC2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AMI Owner ID
}

# Secret Manager data(username and password) to avoid having sensitive secrets in plaintext code
data "aws_secretsmanager_secret_version" "master_username" {
  secret_id = "ADMIN_USERNAME"
}

data "aws_secretsmanager_secret_version" "master_password" {
  secret_id = "ADMIN_PASSWORD"
}
