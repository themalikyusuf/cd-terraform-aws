################################################################################
# Use module in creating RDS
################################################################################

# RDS instance. Multi AZ for high availability
module "ecommerce_db" {
  source                = "./modules/rds"
  allocated_storage     = 50 # dummy value
  max_allocated_storage = 0  # dummy value
  engine                = "mysql"
  engine_version        = "8.0.28"
  instance_class        = "db.t3.medium" # dummy value
  master_username        = data.aws_secretsmanager_secret_version.master_username.secret_string
  master_password        = data.aws_secretsmanager_secret_version.master_password.secret_string
  project_name           = local.project_name
  multi_az               = true
  maintenance_window     = "sat:13:00-sat:14:00"
  backup_window          = "01:00-02:00"
  storage_type           = "io1"
  iops                   = 100 # dummy value
  subnet_ids             = [module.ecommerce_vpc.private_subnets[0], module.ecommerce_vpc.private_subnets[1]]
  vpc_security_group_ids = [aws_security_group.ecommerce_db_sg.id]
}

# NAT instance to be used in accessing the RDS from the public
resource "aws_instance" "ecommerce_db_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecommerce_db_nat.id]
  key_name               = var.key_name
  subnet_id              = module.ecommerce_vpc.public_subnets[0]

  tags = local.common_tags
}

# Elastic IP for NAT EC2 Instance
resource "aws_eip" "ecommerce_db" {
  instance = aws_instance.ecommerce_db_ec2.id
  vpc      = true

  tags = local.common_tags

  depends_on = [aws_instance.ecommerce_db_ec2]
}
