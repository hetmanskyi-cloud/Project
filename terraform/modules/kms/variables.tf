# --- KMS Module Variables --- #

# Define the AWS region where resources are created
variable "aws_region" {
  description = "AWS region where resources are created" # Region for AWS resources
  type        = string
}

# AWS account ID used to configure KMS key permissions
variable "aws_account_id" {
  description = "AWS account ID for setting up KMS key permissions" # Account ID for permissions
  type        = string
}

# Name assigned to the KMS key for identification and tagging
variable "kms_key_name" {
  description = "Name of the KMS key" # Key name, optionally customizable
  type        = string
  default     = "vpc-log-kms-key" # Default name for the KMS key
}

# Specify the environment (e.g., dev, prod)
variable "environment" {
  description = "Environment for the resources (dev, prod, etc.)" # Environment for tagging
  type        = string
}

# Name prefix to apply to all KMS resources in this module
variable "name_prefix" {
  description = "Name prefix for KMS resources" # Prefix for naming consistency
  type        = string
}
