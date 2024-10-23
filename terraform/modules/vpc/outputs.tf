# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.dev_vpc.id
}

# Output the public subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

# Output the private subnet 1 ID
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.dev_private_subnet_1.id
}

# Output the private subnet 2 ID
output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.dev_private_subnet_2.id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.dev_igw.id
}

# Output the route table ID for the public subnet
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.dev_public_route_table.id
}
