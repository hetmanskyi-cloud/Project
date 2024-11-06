# --- VPC Configuration --- #

# Define the VPC configuration with CIDR block and DNS support enabled
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block # The CIDR block for the VPC
  enable_dns_support   = true               # Enable DNS support to resolve internal hostnames within the VPC
  enable_dns_hostnames = true               # Enable DNS hostnames for instances with public IPs

  tags = {
    Name        = "${var.name_prefix}-vpc" # Dynamic name for the VPC using the provided prefix
    Environment = var.environment          # Environment tag for resource organization
  }
}

# --- Public Subnet 1 Configuration --- #

# Define the first public subnet with public IP assignment enabled
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id                 # Link the subnet to the created VPC
  cidr_block              = var.public_subnet_cidr_block_1 # CIDR block for the first public subnet
  map_public_ip_on_launch = true                           # Automatically assign a public IP to instances in this subnet
  availability_zone       = var.availability_zone_public_1 # Specify the Availability Zone for this subnet

  tags = {
    Name        = "${var.name_prefix}-public-subnet-1" # Dynamic name for the public subnet
    Environment = var.environment                      # Environment tag for resource organization
  }
}

# --- Public Subnet 2 Configuration --- #

# Define the second public subnet with public IP assignment enabled
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id                 # Link the subnet to the created VPC
  cidr_block              = var.public_subnet_cidr_block_2 # CIDR block for the second public subnet
  map_public_ip_on_launch = true                           # Automatically assign a public IP to instances in this subnet
  availability_zone       = var.availability_zone_public_2 # Specify the Availability Zone for this subnet

  tags = {
    Name        = "${var.name_prefix}-public-subnet-2" # Dynamic name for the public subnet
    Environment = var.environment                      # Environment tag for resource organization
  }
}

# --- Private Subnet 1 Configuration --- #

# Define the first private subnet, without public IP assignment
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id                  # Link the private subnet to the VPC
  cidr_block        = var.private_subnet_cidr_block_1 # CIDR block for the private subnet 1
  availability_zone = var.availability_zone_private_1 # Specify the Availability Zone for this subnet

  tags = {
    Name        = "${var.name_prefix}-private-subnet-1" # Dynamic name for private subnet 1
    Environment = var.environment                       # Environment tag for resource organization
  }
}

# --- Private Subnet 2 Configuration --- #

# Define the second private subnet, without public IP assignment
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id                  # Link the private subnet to the VPC
  cidr_block        = var.private_subnet_cidr_block_2 # CIDR block for the private subnet 2
  availability_zone = var.availability_zone_private_2 # Specify the Availability Zone for this subnet

  tags = {
    Name        = "${var.name_prefix}-private-subnet-2" # Dynamic name for private subnet 2
    Environment = var.environment                       # Environment tag for resource organization
  }
}