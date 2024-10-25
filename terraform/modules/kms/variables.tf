# modules/kms/variables.tf
variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID for setting up KMS key permissions"
  type        = string
}

variable "kms_key_name" {
  description = "Name of the KMS key"
  type        = string
  default     = "vpc-log-kms-key" # Optional default name, can be overridden
}

variable "environment" {
  description = "Environment for the resources (dev, prod, etc.)"
  type        = string
}

# Define the name prefix for resources in the KMS module
variable "name_prefix" {
  description = "Name prefix for KMS resources"
  type        = string
}