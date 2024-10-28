# --- RDS Module Variables --- #

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for the resources (e.g., dev, prod)"
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB for the RDS instance"
  type        = number
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
}

# Engine type for the RDS instance (e.g., "mysql", "postgres")
variable "engine" {
  description = "Database engine for the RDS instance"
  type        = string
}

# Database engine version (e.g., "8.0" for MySQL, "13" for PostgreSQL)
variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "username" {
  description = "Master username for RDS"
  type        = string
}

variable "password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs for RDS access"
  type        = list(string)
}

# List of private subnet IDs for RDS (e.g., Private Subnet 1)
variable "subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Number of days to retain RDS backups"
  type        = number
}

variable "backup_window" {
  description = "Preferred window for automated RDS backups"
  type        = string
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for RDS high availability"
  type        = bool
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection for RDS instance"
  type        = bool
}

variable "read_replica_count" {
  description = "Number of read replicas for RDS"
  type        = number
}

# --- VPC ID for RDS --- #

# The ID of the VPC where the RDS instance will be hosted
variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance is hosted"
  type        = string
}

# --- EC2 Security Group ID --- #
variable "ec2_security_group_id" {
  description = "ID of the Security Group for EC2 instances"
  type        = string
}

# CIDR block for allowing access to the RDS database
variable "allowed_cidr" {
  description = "CIDR block to allow access to RDS from public subnet"
  type        = string
}

# --- Database Port for RDS --- #

# Port for the RDS database (e.g., 3306 for MySQL)
variable "db_port" {
  description = "Database port for RDS (e.g., 3306 for MySQL)"
  type        = number
}

