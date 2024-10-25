# Define the VPC configuration
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block # Use the variable from the variables.tf file
  enable_dns_support   = true               # Enable DNS support for the VPC
  enable_dns_hostnames = true               # Enable DNS hostnames for the VPC

  tags = {
    Name        = "${var.name_prefix}-vpc" # Dynamic name for the VPC
    Environment = var.environment          # Use environment variable for tagging
  }
}

# Public subnet configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id               # Reference the VPC by its ID
  cidr_block              = var.public_subnet_cidr_block # CIDR block for the subnet
  map_public_ip_on_launch = false                        # Do not automatically assign public IP addresses to instances in this subnet
  availability_zone       = var.availability_zone_public # Availability zone for the subnet

  tags = {
    Name        = "${var.name_prefix}-public-subnet" # Dynamic name for the public subnet
    Environment = var.environment                    # Use environment variable for tagging
  }
}

# Internet gateway configuration
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id # Reference the VPC by its ID

  tags = {
    Name        = "${var.name_prefix}-igw" # Dynamic name for the internet gateway
    Environment = var.environment          # Use environment variable for tagging
  }
}

# Route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id # Reference the VPC by its ID

  # Route all internet-bound traffic through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"                 # Default route for all internet-bound traffic
    gateway_id = aws_internet_gateway.igw.id # Use the Internet Gateway for this route
  }

  tags = {
    Name        = "${var.name_prefix}-public-route-table" # Dynamic name for the route table
    Environment = var.environment                         # Use environment variable for tagging
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id           # Reference the public subnet by its ID
  route_table_id = aws_route_table.public_route_table.id # Associate the route table with the public subnet
}

# Private subnet 1 configuration
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id                  # Reference the VPC by its ID
  cidr_block        = var.private_subnet_cidr_block_1 # CIDR block for the private subnet 1
  availability_zone = var.availability_zone_private_1 # Availability zone for the private subnet 1

  tags = {
    Name        = "${var.name_prefix}-private-subnet-1" # Dynamic name for private subnet 1
    Environment = var.environment                       # Use environment variable for tagging
  }
}

# Private subnet 2 configuration
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id                  # Reference the VPC by its ID
  cidr_block        = var.private_subnet_cidr_block_2 # CIDR block for the private subnet 2
  availability_zone = var.availability_zone_private_2 # Availability zone for the private subnet 2

  tags = {
    Name        = "${var.name_prefix}-private-subnet-2" # Dynamic name for private subnet 2
    Environment = var.environment                       # Use environment variable for tagging
  }
}
