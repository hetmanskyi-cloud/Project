# Define the VPC configuration
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr_block # Use the variable from the variables.tf file
  enable_dns_support   = true               # Enable DNS support for the VPC
  enable_dns_hostnames = true               # Enable DNS hostnames for the VPC

  tags = {
    Name = "dev-vpc" # Tag the VPC for easier identification
  }
}

# Public subnet configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id           # Reference the VPC by its ID
  cidr_block              = var.public_subnet_cidr_block # CIDR block for the subnet
  map_public_ip_on_launch = true                         # Automatically assign public IP addresses to instances in this subnet
  availability_zone       = var.availability_zone_public # Availability zone for the subnet

  tags = {
    Name = "dev-public-subnet" # Tag the subnet for easier identification
  }
}

# Internet gateway configuration
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id # Reference the VPC by its ID

  tags = {
    Name = "dev-igw" # Tag the internet gateway for easier identification
  }
}

# Route table for the public subnet
resource "aws_route_table" "dev_public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id # Reference the VPC by its ID

  # Route all internet-bound traffic through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"                     # Default route for all internet-bound traffic
    gateway_id = aws_internet_gateway.dev_igw.id # Use the Internet Gateway for this route
  }

  tags = {
    Name = "dev-public-route-table" # Tag for identifying the route table
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id               # Reference the public subnet by its ID
  route_table_id = aws_route_table.dev_public_route_table.id # Associate the route table with the public subnet
}

# Private subnet 1 configuration
resource "aws_subnet" "dev_private_subnet_1" {
  vpc_id            = aws_vpc.dev_vpc.id              # Reference the VPC by its ID
  cidr_block        = var.private_subnet_cidr_block_1 # CIDR block for the private subnet 1
  availability_zone = var.availability_zone_private_1 # Availability zone for the private subnet 1

  tags = {
    Name = "dev-private-subnet-1" # Tag for identifying the private subnet 1
  }
}

# Private subnet 2 configuration
resource "aws_subnet" "dev_private_subnet_2" {
  vpc_id            = aws_vpc.dev_vpc.id              # Reference the VPC by its ID
  cidr_block        = var.private_subnet_cidr_block_2 # CIDR block for the private subnet 2
  availability_zone = var.availability_zone_private_2 # Availability zone for the private subnet 2

  tags = {
    Name = "dev-private-subnet-2" # Tag for identifying the private subnet 2
  }
}
