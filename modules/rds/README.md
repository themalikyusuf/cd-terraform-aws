#### Example usage to create an RDS instance
```
module "database" {
  source                 = "git@github.com:themalikyusuf/cd-terraform-aws.git//modules/rds?ref=main"
  allocated_storage      = 200
  max_allocated_storage  = 300
  engine                 = "mysql"
  engine_version         = "5.7.26"
  instance_class         = "db.m5.large"
  master_username        = data.aws_kms_secrets.encrypted_password.plaintext["root_username"]
  master_password        = data.aws_kms_secrets.encrypted_password.plaintext["root_password"]
  project_name           = "test"
  subnet_ids             = [data.aws_subnets.production.ids[0], data.aws_subnets.production.ids[1]]
  vpc_security_group_ids = [aws_security_group.security_group.id]
}


```
