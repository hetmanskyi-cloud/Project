# VPC variables

# Define the AWS region where resources will be created
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

# Define the VPC CIDR block
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

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

# Define the CIDR block for the private subnet 1
variable "private_subnet_cidr_block_1" {
  description = "The CIDR block for the private subnet 1"
  type        = string
}

# Define the availability zone for the private subnet 1
variable "availability_zone_private_1" {
  description = "The availability zone for the private subnet 1"
  type        = string
}

# Define the CIDR block for the private subnet 2
variable "private_subnet_cidr_block_2" {
  description = "The CIDR block for the private subnet 2"
  type        = string
}

# Define the availability zone for the private subnet 2
variable "availability_zone_private_2" {
  description = "The availability zone for the private subnet 2"
  type        = string
}

# AWS Account ID variable used for policies and resources
variable "aws_account_id" {
  description = "AWS Account ID for KMS key policy"
  type        = string
}
