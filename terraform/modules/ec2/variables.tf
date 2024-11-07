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

# AMI ID for the EC2 instances
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

# EC2 Root Volume Configuration
variable "volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the EC2 Security Group"
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

# --- Auto Scaling Scaling Policies Configuration --- #

# CPU utilization threshold to scale out
variable "scale_out_cpu_threshold" {
  description = "CPU utilization threshold to scale out EC2 instances"
  type        = number
}

# CPU utilization threshold to scale in
variable "scale_in_cpu_threshold" {
  description = "CPU utilization threshold to scale in EC2 instances"
  type        = number
}

# Cooldown period for Auto Scaling actions
variable "autoscaling_cooldown" {
  description = "Cooldown period (in seconds) between Auto Scaling actions"
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

# --- User Data Script for EC2 Configuration --- #

# Bash script or Ansible playbook used for initial setup and configuration of EC2 instances
variable "user_data" {
  description = "Script to configure WordPress on instance launch (e.g., deploy_wordpress.sh)"
  type        = string
  default     = ""
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

# --- Security Configuration --- #

# Security Group ID for SSM endpoint
variable "ssm_endpoint_sg_id" {
  description = "ID of the Security Group for SSM endpoint"
  type        = string
}

# Security Group ID for SSH access to EC2 instances
variable "ssh_security_group_id" {
  description = "ID of the SSH Security Group for EC2 instances"
  type        = string
}

# --- KMS Key ARN for CloudWatch Logs Encryption --- #

# Specifies the ARN of the KMS key used to encrypt CloudWatch logs
variable "kms_key_arn" {
  description = "ARN of the KMS key for encrypting CloudWatch logs"
  type        = string
}

# --- Public Subnet CIDR Blocks --- #

# Defines CIDR blocks for public subnets, used in security group rules
variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets. Can be used for controlling allowed IP ranges in ALB Security Group or other access configurations."
  type        = list(string)
}

# --- SSH Key Pair Name --- #

# Name of the SSH key used for secure access to EC2 instances
variable "ssh_key_name" {
  description = "The name of the SSH key pair to access EC2 instances"
  type        = string
}

# --- CloudWatch Log Group --- #
# Configuration settings for CloudWatch log retention

# Define log retention period for CloudWatch Log Group
variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}
