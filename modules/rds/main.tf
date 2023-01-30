################################################################################
# This file contains RDS service resources
################################################################################

resource "aws_db_instance" "rds_task" {
  identifier     = "${var.project_name}-rds"
  username       = var.master_username
  password       = var.master_password
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  db_subnet_group_name            = aws_db_subnet_group.rds_task.name
  delete_automated_backups        = var.delete_automated_backups
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  final_snapshot_identifier       = "${var.project_name}-final-snapshot"
  iops                            = var.iops
  kms_key_id                      = var.kms_key_id
  maintenance_window              = var.maintenance_window
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = aws_iam_role.rds_task.arn
  multi_az                        = var.multi_az
  parameter_group_name            = aws_db_parameter_group.rds_task.name
  performance_insights_enabled    = var.performance_insights_enabled
  replicate_source_db             = var.replicate_source_db_arn
  skip_final_snapshot             = var.skip_final_snapshot
  storage_encrypted               = var.storage_encrypted
  storage_type                    = var.storage_type
  vpc_security_group_ids          = var.vpc_security_group_ids
}

resource "aws_db_parameter_group" "rds_task" {
  name        = "${var.project_name}-pg"
  family      = var.parameter_group_family
  description = "Parameter Group for ${var.project_name} Database"
}

resource "aws_db_subnet_group" "rds_task" {
  name        = "${var.project_name}-sg"
  subnet_ids  = var.subnet_ids
  description = "Subnet Group for ${var.project_name} Database"
}

resource "aws_iam_role" "rds_task" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_task.json
}

resource "aws_iam_role_policy_attachment" "rds_task" {
  role       = aws_iam_role.rds_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_task" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
