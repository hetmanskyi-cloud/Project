# --- AWS Region Configuration --- #

# The AWS region where resources will be created
variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

# --- VPC and Subnet Configuration --- #

# The CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# The CIDR block for the first public subnet
variable "public_subnet_cidr_block_1" {
  description = "The CIDR block for the first public subnet"
  type        = string
}

# The CIDR block for the second public subnet
variable "public_subnet_cidr_block_2" {
  description = "The CIDR block for the second public subnet"
  type        = string
}

# The availability zone for the first public subnet
variable "availability_zone_public_1" {
  description = "The availability zone for the first public subnet"
  type        = string
}

# The availability zone for the second public subnet
variable "availability_zone_public_2" {
  description = "The availability zone for the second public subnet"
  type        = string
}

# The CIDR block for the first private subnet
variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the first private subnet"
  type        = string
}

# The CIDR block for the second private subnet
variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
}

# The availability zone for the first private subnet
variable "availability_zone_private_1" {
  description = "The availability zone for the first private subnet"
  type        = string
}

# The availability zone for the second private subnet
variable "availability_zone_private_2" {
  description = "The availability zone for the second private subnet"
  type        = string
}

# --- AWS Account and Resource Naming --- #

# AWS Account ID for permissions and KMS key policy
variable "aws_account_id" {
  description = "AWS Account ID for permissions and KMS key policy"
  type        = string
}

# The environment for resource organization (e.g., dev, prod)
variable "environment" {
  description = "The environment for resource organization (e.g., dev, prod)"
  type        = string
}

# Prefix for resource names, used to differentiate environments
variable "name_prefix" {
  description = "Prefix for resource names, used to differentiate environments"
  type        = string
}

# Enable or disable the Internet Monitor feature
variable "enable_internet_monitor" {
  description = "Enable or disable the Internet Monitor feature"
  type        = bool
  default     = false
}

# Percentage of traffic for monitoring
variable "traffic_percentage" {
  description = "Percentage of traffic for monitoring"
  type        = number
  default     = 100
}

# --- EC2 Configuration --- #

# The AMI ID to use for EC2 instances
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

# Instance type for the EC2 instances
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

# Desired number of instances in the Auto Scaling Group
variable "autoscaling_desired" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
}

# Minimum number of instances in the Auto Scaling Group
variable "autoscaling_min" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

# Maximum number of instances in the Auto Scaling Group
variable "autoscaling_max" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

# The size of the root EBS volume in GB
variable "volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
}

# The name of the SSH key pair to access EC2 instances
variable "ssh_key_name" {
  description = "The name of the SSH key pair to access EC2 instances"
  type        = string
}

# Enable or disable SSH access for EC2 instances (set to true for testing)
variable "allow_ssh_access" {
  description = "Enable or disable SSH access for EC2 instances (set to true for testing)"
  type        = bool
}

# Number of days to retain CloudWatch logs
variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}

# --- Auto Scaling Scaling Policies Configuration --- #

# CPU utilization threshold to scale out EC2 instances
variable "scale_out_cpu_threshold" {
  description = "CPU utilization threshold to scale out EC2 instances"
  type        = number
}

# CPU utilization threshold to scale in EC2 instances
variable "scale_in_cpu_threshold" {
  description = "CPU utilization threshold to scale in EC2 instances"
  type        = number
}

# Cooldown period (in seconds) between Auto Scaling actions
variable "autoscaling_cooldown" {
  description = "Cooldown period (in seconds) between Auto Scaling actions"
  type        = number
}

# --- RDS Configuration --- #

# Storage size in GB for the RDS instance
variable "allocated_storage" {
  description = "Storage size in GB for the RDS instance"
  type        = number
}

# Instance class for RDS
variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
}

# Database engine for the RDS instance (e.g., 'mysql', 'postgres')
variable "engine" {
  description = "Database engine for the RDS instance (e.g., 'mysql', 'postgres')"
  type        = string
}

# Database engine version
variable "engine_version" {
  description = "Database engine version"
  type        = string
}

# Master username for RDS
variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

# Master password for RDS
variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

# Initial database name
variable "db_name" {
  description = "Initial database name"
  type        = string
}

# Database port for RDS (e.g., 3306 for MySQL)
variable "db_port" {
  description = "Database port for RDS (e.g., 3306 for MySQL)"
  type        = number
}

# Number of days to retain RDS backups
variable "backup_retention_period" {
  description = "Number of days to retain RDS backups"
  type        = number
}

# Preferred window for automated RDS backups
variable "backup_window" {
  description = "Preferred window for automated RDS backups"
  type        = string
}

# Enable Multi-AZ deployment for RDS high availability
variable "multi_az" {
  description = "Enable Multi-AZ deployment for RDS high availability"
  type        = bool
}

# Enable or disable deletion protection for RDS instance
variable "enable_deletion_protection" {
  description = "Enable or disable deletion protection for RDS instance"
  type        = bool
}

# Skip final snapshot when deleting the RDS instance
variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the RDS instance"
  type        = bool
  default     = false
}

# Enable or disable enhanced monitoring for RDS instances
variable "enable_monitoring" {
  description = "Enable or disable enhanced monitoring for RDS instances"
  type        = bool
  default     = false
}

# --- Redis Configuration --- #

# Redis host endpoint for WordPress caching
variable "redis_host" {
  description = "Redis host endpoint for WordPress caching"
  type        = string
}

# Redis port for caching
variable "redis_port" {
  description = "Redis port for caching"
  type        = number
}
