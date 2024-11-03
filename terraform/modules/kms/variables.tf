# --- KMS Module Variables --- #

# AWS Account ID for configuring permissions in the KMS key policy
variable "aws_account_id" {
  description = "AWS Account ID for configuring permissions in the KMS key policy"
  type        = string
}

# AWS Region where the resources are created
variable "aws_region" {
  description = "AWS Region where the resources are created"
  type        = string
}

# Prefix for naming KMS and related resources
variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

# Environment label for tracking resources (dev, stage, prod)
variable "environment" {
  description = "Environment label for organizing resources"
  type        = string
}
