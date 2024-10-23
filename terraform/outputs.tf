# VPC outputs
# Output the VPC ID from the VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id # Ссылка на выходное значение из модуля vpc
}

# Output the public subnet ID from the VPC module
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id # Ссылка на выходное значение из модуля vpc
}

# Output the private subnet 1 ID from the VPC module
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = module.vpc.private_subnet_1_id # Ссылка на выходное значение из модуля vpc
}

# Output the private subnet 2 ID from the VPC module
output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = module.vpc.private_subnet_2_id # Ссылка на выходное значение из модуля vpc
}

# Output the Internet Gateway ID from the VPC module
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id # Ссылка на выходное значение из модуля vpc
}
