# --- AWS Region --- #

# Define the AWS region where resources will be created
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

# --- VPC and Subnet Configuration --- #

# Define the VPC CIDR block
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# Define the CIDR block and availability zone for the public subnet
variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "availability_zone_public" {
  description = "The availability zone for the public subnet"
  type        = string
}

# Define the CIDR block and availability zone for the private subnets
variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the first private subnet"
  type        = string
}

variable "availability_zone_private_1" {
  description = "The availability zone for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
}

variable "availability_zone_private_2" {
  description = "The availability zone for the second private subnet"
  type        = string
}

# --- AWS Account and Resource Naming --- #

variable "aws_account_id" {
  description = "AWS Account ID for KMS key policy"
  type        = string
}

variable "environment" {
  description = "Environment for the infrastructure (e.g., dev, prod)"
  type        = string
}

variable "name_prefix" {
  description = "The prefix for resource names, used to differentiate environments (e.g., dev, prod)"
  type        = string
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
  description = "Database engine for the RDS instance (e.g., MySQL, PostgreSQL)"
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
  description = "Database port for MySQL RDS"
  type        = number
}

variable "redis_host" {
  description = "Redis host endpoint for WordPress caching"
  type        = string
}

variable "redis_port" {
  description = "Redis port for caching"
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

variable "read_replica_count" {
  description = "Number of read replicas for RDS"
  type        = number
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
