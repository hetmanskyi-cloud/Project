# --- Naming and Environment Configuration --- #

# Define the name prefix for resources
variable "name_prefix" {
  description = "The prefix for resource names, used to differentiate environments (e.g., dev, prod)"
  type        = string
}

# Define the environment (e.g., dev, prod)
variable "environment" {
  description = "Environment for the infrastructure (e.g., dev, prod)"
  type        = string
}

# --- VPC and Instance Configuration --- #

# VPC ID to associate with the EC2 instances
variable "vpc_id" {
  description = "The ID of the VPC where EC2 instances will be launched"
  type        = string
}

# AMI ID for the EC2 instances
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

# --- Subnet Configuration --- #

# List of subnet IDs for launching EC2 instances
variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group, typically the public subnet"
  type        = list(string)
}

# EC2 instance type
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

# --- Auto-scaling Configuration --- #

# Auto-scaling group desired capacity
variable "autoscaling_desired" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
}

# Auto-scaling group minimum size
variable "autoscaling_min" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

# Auto-scaling group maximum size
variable "autoscaling_max" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

# --- Database Configuration for WordPress --- #

# Database name for WordPress
variable "db_name" {
  description = "Database name for WordPress"
  type        = string
}

# Database username for WordPress
variable "db_user" {
  description = "Database username for WordPress"
  type        = string
}

# Database password for WordPress
variable "db_password" {
  description = "Database password for WordPress"
  type        = string
}

# Database host endpoint for WordPress
variable "db_host" {
  description = "Database host endpoint for WordPress"
  type        = string
}

# Database port for MySQL RDS
variable "db_port" {
  description = "Database port for MySQL RDS"
  type        = number
  default     = 3306
}

# --- Redis Configuration for WordPress Cache --- #

# Redis host endpoint for WordPress cache
variable "redis_host" {
  description = "Redis host endpoint for WordPress cache"
  type        = string
}

# Redis port for WordPress cache
variable "redis_port" {
  description = "Redis port for WordPress cache"
  type        = number
  default     = 6379
}
