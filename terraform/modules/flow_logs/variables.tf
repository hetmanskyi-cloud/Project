# --- Naming and Environment Configuration --- #

# Define a prefix for naming resources
variable "name_prefix" {
  description = "The prefix for naming resources" # Custom prefix for resource identification
  type        = string
}

# Environment tag for resources (e.g., dev, prod)
variable "environment" {
  description = "Environment for tagging resources (e.g., dev, prod)" # Environment label for resource grouping
  type        = string
}

# --- VPC and KMS Configuration --- #

# VPC ID where Flow Logs will be enabled
variable "vpc_id" {
  description = "The ID of the VPC where Flow Logs will be enabled" # Specifies the target VPC for flow logging
  type        = string
}

# KMS key ARN for encrypting Flow Logs in CloudWatch
variable "kms_key_arn" {
  description = "The ARN of the KMS key for encrypting Flow Logs in CloudWatch" # KMS key to secure CloudWatch logs
  type        = string
}

# --- IAM Role Configuration --- #

# IAM role ARN for VPC Flow Logs
variable "flow_logs_role_arn" {
  description = "The ARN of the IAM role for VPC Flow Logs" # IAM role used by Flow Logs
  type        = string
}
