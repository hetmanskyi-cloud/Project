# --- Outputs from Modules --- #

output "public_subnet_1_id" {
  description = "The ID of the first public subnet"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "The ID of the second public subnet"
  value       = module.vpc.public_subnet_2_id
}

output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = module.vpc.private_subnet_2_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "ssm_endpoint_sg_id" {
  description = "The Security Group ID for SSM endpoint"
  value       = module.vpc.ssm_endpoint_sg_id
}

# EC2 Outputs
output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances in the Auto Scaling Group"
  value       = module.ec2.ec2_instance_public_ips
}

# RDS Outputs
output "db_endpoint" {
  description = "The endpoint of the RDS database"
  value       = module.rds.db_endpoint
}
