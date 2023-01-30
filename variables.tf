################################################################################
# Varible definitions
################################################################################

variable "nat_access_ips" {
  description = "IP address(e)s to allow to the NAT instance"
  type        = list(any)
}

variable "azs" {
  type        = list(any)
  description = "Region availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "private_subnets" {
  type        = list(any)
  description = "Private subnets CIDR"
}

variable "public_subnets" {
  type        = list(any)
  description = "Public subnets CIDR"
}

variable "key_name" {
  type        = string
  description = "Key pair name to use for NAT EC2"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "profile" {
  type        = string
  description = "AWS Profile"
}
