# --- Configuration for Internet Monitor Module --- #

# Toggle for enabling/disabling the Internet Monitor
variable "enable_internet_monitor" {
  description = "Enable or disable the Internet Monitor for network monitoring" # Controls monitor creation
  type        = bool
  default     = false
}

# Define traffic percentage for monitoring
variable "traffic_percentage" {
  description = "Percentage of traffic to monitor" # Sets the portion of network traffic to monitor
  type        = number
  default     = 100
}

# --- Network Configuration --- #

# The VPC ID for which monitoring is set up
variable "vpc_id" {
  description = "VPC ID to link with the Internet Monitor" # VPC to be monitored
  type        = string
}

# AWS Region where resources are created
variable "aws_region" {
  description = "AWS region for resource creation" # Specifies resource deployment region
  type        = string
}

# --- Resource Naming and Environment Tags --- #

# Name prefix for resources
variable "name_prefix" {
  description = "Prefix for naming resources" # Custom prefix for identifying resources
  type        = string
}

# Environment for tagging purposes
variable "environment" {
  description = "Environment tag for the resources" # Tag for environment (e.g., dev, prod)
  type        = string
}
