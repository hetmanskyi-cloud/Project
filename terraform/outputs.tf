# --- VPC and Subnet Outputs --- #

# Output the VPC ID from the VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id # Reference to the output value from the VPC module
}

# Output the public subnet ID from the VPC module
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id # Reference to the public subnet ID output in the VPC module
}

# Output the private subnet 1 ID from the VPC module
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = module.vpc.private_subnet_1_id # Reference to the first private subnet ID output in the VPC module
}

# Output the private subnet 2 ID from the VPC module
output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = module.vpc.private_subnet_2_id # Reference to the second private subnet ID output in the VPC module
}

# Output the Internet Gateway ID from the VPC module
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id # Reference to the Internet Gateway ID output in the VPC module
}

# --- Monitoring Outputs --- #

# Output the Internet Monitor ID only if enabled
output "internet_monitor_id" {
  description = "The ID of the Internet Monitor instance"
  value       = var.enable_internet_monitor ? module.internet_monitor.internet_monitor_id : null # Outputs the Internet Monitor ID if monitoring is enabled, otherwise returns null
}

# --- Flow Logs Outputs --- #

# Output the CloudWatch Log Group ARN for the VPC Flow Logs
output "vpc_flow_logs_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for VPC Flow Logs"
  value       = module.flow_logs.cloudwatch_log_group_arn # Reference to the CloudWatch Log Group ARN from the Flow Logs module
}

# Output the IAM role ARN used by the Flow Logs
output "flow_logs_role_arn" {
  description = "The ARN of the IAM role for VPC Flow Logs"
  value       = module.flow_logs.flow_logs_role_arn # Reference to the IAM role ARN output from the Flow Logs module
}

# --- EC2 Module Outputs --- # 

output "ec2_asg_name" {
  description = "The name of the Auto Scaling Group for EC2 instances"
  value       = module.ec2.ec2_asg_name
}

output "ec2_instance_ids" {
  description = "The list of instance IDs in the Auto Scaling Group"
  value       = module.ec2.ec2_instance_ids
}

output "ec2_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for EC2 instances"
  value       = module.ec2.ec2_log_group_arn
}

# --- S3 Module Outputs --- #

# Output the ARN of the Terraform state bucket
output "terraform_state_bucket_arn" {
  description = "The ARN of the S3 bucket for Terraform remote state"
  value       = module.s3.terraform_state_bucket_arn
}

# Output the name of the DynamoDB table for Terraform state locking
output "terraform_locks_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  value       = module.s3.terraform_locks_table_name
}

# Output the ARN of the WordPress media bucket
output "wordpress_media_bucket_arn" {
  description = "The ARN of the S3 bucket for WordPress media storage"
  value       = module.s3.wordpress_media_bucket_arn
}

# Output the ARN of the WordPress scripts bucket
output "wordpress_scripts_bucket_arn" {
  description = "The ARN of the S3 bucket for WordPress setup scripts"
  value       = module.s3.wordpress_scripts_bucket_arn
}

# --- RDS Outputs --- #

# Output the endpoint of the RDS database
output "db_host" {
  description = "The endpoint of the RDS database"
  value       = module.rds.db_host
}

# Output the database name
output "db_name" {
  description = "The name of the RDS database"
  value       = module.rds.db_name
}

# Output the master username for the database
output "db_username" {
  description = "The master username for the RDS database"
  value       = module.rds.db_username
}
