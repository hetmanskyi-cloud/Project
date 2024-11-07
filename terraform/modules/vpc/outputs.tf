# --- VPC Outputs --- #

# Output the VPC ID for reference in other modules or resources
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

# --- Public Subnet Outputs --- #

# Output the ID of the first public subnet for further configurations
output "public_subnet_1_id" {
  description = "The ID of the first public subnet"
  value       = aws_subnet.public_subnet_1.id
}

# Output the ID of the second public subnet for further configurations
output "public_subnet_2_id" {
  description = "The ID of the second public subnet"
  value       = aws_subnet.public_subnet_2.id
}

# --- Private Subnet Outputs --- #

# Output the ID of the first private subnet for secure resource placement
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.private_subnet_1.id
}

# Output the ID of the second private subnet for secure resource placement
output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.private_subnet_2.id
}

# --- Internet Gateway Output --- #

# Output the Internet Gateway ID to configure public routing
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# --- SSM Endpoint Security Group Output --- #

# Output the ID of the Security Group for the SSM endpoint
output "ssm_endpoint_sg_id" {
  description = "The Security Group ID for the SSM endpoint"
  value       = aws_security_group.ssm_endpoint_sg.id
}

# --- Additional Outputs for CIDR Blocks --- #

# Output the CIDR block for the first public subnet
output "public_subnet_cidr_block_1" {
  description = "CIDR block for the first public subnet"
  value       = aws_subnet.public_subnet_1.cidr_block
}

# Output the CIDR block for the second public subnet
output "public_subnet_cidr_block_2" {
  description = "CIDR block for the second public subnet"
  value       = aws_subnet.public_subnet_2.cidr_block
}

# Output the CIDR block for the first private subnet
output "private_subnet_cidr_block_1" {
  description = "CIDR block for the first private subnet"
  value       = aws_subnet.private_subnet_1.cidr_block
}

# Output the CIDR block for the second private subnet
output "private_subnet_cidr_block_2" {
  description = "CIDR block for the second private subnet"
  value       = aws_subnet.private_subnet_2.cidr_block
}

# Output the Security Group ID for EC2 instances
output "ssh_security_group_id" {
  description = "The ID of the SSH Security Group for EC2 instances"
  value       = aws_security_group.ssh_sg.id
}