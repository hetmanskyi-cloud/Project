# --- Internet Monitor Module Configuration --- #

# Enable or disable the Internet Monitor
variable "enable_internet_monitor" {
  description = "Enable or disable the Internet Monitor for network traffic monitoring" # Controls monitor creation
  type        = bool
  default     = false
}

# Set the percentage of VPC traffic to monitor
variable "traffic_percentage" {
  description = "Percentage of network traffic to monitor in Internet Monitor" # Specifies traffic monitoring intensity
  type        = number
  default     = 100
}

# --- Network and Region Configuration --- #

# VPC ID associated with Internet Monitor
variable "vpc_id" {
  description = "The ID of the VPC to be monitored" # The VPC where Internet Monitor will track traffic
  type        = string
}

# AWS Region where resources will be deployed
variable "aws_region" {
  description = "AWS region for Internet Monitor resource deployment" # Region where resources are created
  type        = string
}

# --- Naming and Environment Tags --- #

# Prefix to apply to resource names
variable "name_prefix" {
  description = "Prefix for naming resources uniquely" # Prefix to identify resources by environment or project
  type        = string
}

# Environment for tagging resources (e.g., dev, prod)
variable "environment" {
  description = "Environment tag for resources (e.g., dev, staging, prod)" # Tag for resource environment grouping
  type        = string
}
