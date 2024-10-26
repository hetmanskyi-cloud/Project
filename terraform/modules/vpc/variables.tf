# --- VPC CIDR Block Configuration --- #

# Define the CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# --- Public Subnet Configuration --- #

# Define the CIDR block for the public subnet
variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
}

# Define the availability zone for the public subnet
variable "availability_zone_public" {
  description = "The availability zone for the public subnet"
  type        = string
}

# --- Private Subnet 1 Configuration --- #

# Define the CIDR block for the first private subnet
variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the first private subnet"
  type        = string
}

# Define the availability zone for the first private subnet
variable "availability_zone_private_1" {
  description = "The availability zone for the first private subnet"
  type        = string
}

# --- Private Subnet 2 Configuration --- #

# Define the CIDR block for the second private subnet
variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
}

# Define the availability zone for the second private subnet
variable "availability_zone_private_2" {
  description = "The availability zone for the second private subnet"
  type        = string
}

# --- AWS and Project Configuration --- #

# AWS Account ID used for policies and permissions in the VPC module
variable "aws_account_id" {
  description = "AWS Account ID for KMS key policy"
  type        = string
}

# The ARN of the KMS key for encrypting CloudWatch log groups
variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string
}

# Prefix used for naming and tagging resources
variable "name_prefix" {
  description = "Prefix for resource names to differentiate projects or environments"
  type        = string
}

# Environment tag to indicate the deployment stage (e.g., dev, staging, prod)
variable "environment" {
  description = "Environment label for resources (e.g., dev, staging, prod)"
  type        = string
}
