# --- S3 Module Variables --- #

# Environment for the resources (dev, stage, prod)
variable "environment" {
  description = "Environment for the resources (e.g., dev, stage, prod)"
  type        = string
}

# Name prefix for S3 resources
variable "name_prefix" {
  description = "Name prefix for S3 resources"
  type        = string
}
