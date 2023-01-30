################################################################################
# Varible definitions
################################################################################

variable "allocated_storage" {
  type        = number
  description = "The amount of allocated storage"
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage"
}

variable "instance_class" {
  type        = string
  description = "The RDS instance class"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "vpc_security_group_ids" {
  type        = list(any)
  description = "List of VPC security groups to associate"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines if a final DB snapshot is created before the DB instance is deleted"
  default     = false
}

variable "delete_automated_backups" {
  type        = bool
  description = "Determines if automated backups are removed immediately after the DB instance is deleted"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted"
  default     = true
}

variable "monitoring_interval" {
  type        = number
  description = "The interval(secs) between points when Enhanced Monitoring metrics are collected for the DB instance"
  default     = 60
}

variable "backup_retention_period" {
  type        = number
  description = "The days to retain backups for. Must be between 0 and 35."
  default     = 21
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Specifies whether Performance Insights are enabled"
  default     = true
}

variable "subnet_ids" {
  type        = list(any)
  description = "A list of VPC subnet IDs to use for the DB Subnet Group"
}

variable "parameter_group_family" {
  type        = string
  description = "The family of the DB parameter group."
  default     = "mysql8.0"
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "replicate_source_db_arn" {
  type        = string
  description = "Specifies that this resource is a Replicate DB. This correlates to the identifier of another RDS DB to replicate (if replicating within a single region) or ARN of the RDS DB to replicate (if replicating cross-region)"
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
  default     = null
}

variable "master_username" {
  type        = string
  description = "Username for the master DB user. Required unless replicate_source_db is provided"
  default     = null
}

variable "master_password" {
  type        = string
  description = "Password for the master DB user. Required unless replicate_source_db is provided"
  default     = null
}

variable "engine" {
  type        = string
  description = " The database engine to use. Required unless replicate_source_db is provided"
  default     = null
}

variable "engine_version" {
  type        = string
  description = " The database engine version to use. Cannot be specified for a replica DB"
  default     = null
}

variable "storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "gp2"
}

variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = 0
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "sat:04:20-sat:04:50"
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  default     = "03:40-04:10"
}
