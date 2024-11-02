# --- KMS Module Variables --- #

# AWS region for resource creation
variable "aws_region" {
  description = "The AWS region where resources are created"
  type        = string
}

# AWS Account ID for KMS key permissions
variable "aws_account_id" {
  description = "AWS account ID used for setting KMS key permissions"
  type        = string
}

# KMS key name for identification and tagging
variable "kms_key_name" {
  description = "The name of the KMS key for easy identification"
  type        = string
  default     = "vpc-log-kms-key" # Default name for the KMS key
}

# Environment tag (e.g., dev, prod)
variable "environment" {
  description = "The environment label for tagging resources (e.g., dev, prod)"
  type        = string
}

# Prefix for consistent resource naming
variable "name_prefix" {
  description = "The name prefix to apply to all resources in this module"
  type        = string
}