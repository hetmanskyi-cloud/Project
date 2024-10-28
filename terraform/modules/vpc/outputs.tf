# --- VPC Outputs --- #

# Output the VPC ID for reference in other modules or resources
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id # Reference the VPC ID
}

# --- Subnet Outputs --- #

# Output the ID of the public subnet for further configurations
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id # Reference the public subnet ID
}

# Output the ID of the first private subnet for secure resource placement
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.private_subnet_1.id # Reference the first private subnet ID
}

# Output the ID of the second private subnet for secure resource placement
output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.private_subnet_2.id # Reference the second private subnet ID
}

# --- Internet Gateway Outputs --- #

# Output the Internet Gateway ID to configure public routing
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id # Reference the Internet Gateway ID
}

# --- Route Table Outputs --- #

# Output the public route table ID for routing configurations
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_route_table.id # Reference the public route table ID
}

# --- Public Subnet CIDR Block Output --- #

output "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  value       = var.public_subnet_cidr_block
}
