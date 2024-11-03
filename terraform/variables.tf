# --- AWS Region Configuration --- #

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

# --- VPC and Subnet Configuration --- #

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# CIDR blocks and availability zones for public and private subnets

variable "public_subnet_cidr_block_1" {
  description = "The CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_cidr_block_2" {
  description = "The CIDR block for the second public subnet"
  type        = string
}

variable "availability_zone_public_1" {
  description = "The availability zone for the first public subnet"
  type        = string
}

variable "availability_zone_public_2" {
  description = "The availability zone for the second public subnet"
  type        = string
}

variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
}

variable "availability_zone_private_1" {
  description = "The availability zone for the first private subnet"
  type        = string
}

variable "availability_zone_private_2" {
  description = "The availability zone for the second private subnet"
  type        = string
}

# --- AWS Account and Resource Naming --- #

variable "aws_account_id" {
  description = "AWS Account ID for permissions and KMS key policy"
  type        = string
}

variable "environment" {
  description = "The environment for resource organization (e.g., dev, prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names, used to differentiate environments"
  type        = string
}

# --- Monitoring Configuration --- #

variable "enable_internet_monitor" {
  description = "Enable or disable the Internet Monitor feature"
  type        = bool
  default     = false
}

variable "traffic_percentage" {
  description = "Percentage of traffic for monitoring"
  type        = number
  default     = 100
}

# --- EC2 Configuration --- #

variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "autoscaling_desired" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
}

variable "autoscaling_min" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

variable "autoscaling_max" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

# EC2 Root Volume Configuration
variable "volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
}

# SSH Key Pair Name
variable "ssh_key_name" {
  description = "The name of the SSH key pair to access EC2 instances"
  type        = string
}

# User data script to run on instance launch, usually deploy_wordpress.sh
variable "user_data" {
  description = "Script to configure WordPress on instance launch (e.g., deploy_wordpress.sh)"
  type        = string
  default     = ""
}

# Ansible playbook for instance launch as alternative to deploy_wordpress.sh
variable "ansible_playbook_user_data" {
  description = "Ansible playbook to configure WordPress on instance launch"
  type        = string
  default     = ""
}

# --- RDS Configuration --- #

variable "allocated_storage" {
  description = "Storage size in GB for the RDS instance"
  type        = number
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
}

variable "engine" {
  description = "Database engine for the RDS instance (e.g., 'mysql', 'postgres')"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_port" {
  description = "Database port for RDS (e.g., 3306 for MySQL)"
  type        = number
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

variable "enable_deletion_protection" {
  description = "Enable or disable deletion protection for RDS instance"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the RDS instance"
  type        = bool
  default     = false
}

# Enable or disable enhanced monitoring for RDS
variable "enable_monitoring" {
  description = "Enable or disable enhanced monitoring for RDS instances"
  type        = bool
  default     = false
}

# --- Redis Configuration --- #

variable "redis_host" {
  description = "Redis host endpoint for WordPress caching"
  type        = string
}

variable "redis_port" {
  description = "Redis port for caching"
  type        = number
}