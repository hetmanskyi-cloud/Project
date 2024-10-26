# --- VPC Configuration --- #

# Define the VPC configuration with CIDR block and DNS support enabled
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block # The CIDR block for the VPC, defined in variables.tf
  enable_dns_support   = true               # Enable DNS support to resolve internal hostnames within the VPC
  enable_dns_hostnames = true               # Enable DNS hostnames for instances with public IPs

  tags = {
    Name        = "${var.name_prefix}-vpc" # Dynamic name for the VPC using the provided prefix
    Environment = var.environment          # Environment tag for resource organization
  }
}

# --- Subnet Configuration --- #

# Public subnet configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id               # Link the subnet to the created VPC
  cidr_block              = var.public_subnet_cidr_block # CIDR block specific to the public subnet
  map_public_ip_on_launch = false                        # No automatic public IP assignment on launch
  availability_zone       = var.availability_zone_public # Public subnet availability zone

  tags = {
    Name        = "${var.name_prefix}-public-subnet" # Dynamic name for the public subnet using the prefix
    Environment = var.environment                    # Environment tag for resource organization
  }
}

# Internet gateway configuration
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id # Attach the internet gateway to the VPC

  tags = {
    Name        = "${var.name_prefix}-igw" # Dynamic name for the internet gateway
    Environment = var.environment          # Environment tag for resource organization
  }
}

# --- Private Subnets Configuration --- #

# Private subnet 1 configuration
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id                  # Link the private subnet to the VPC
  cidr_block        = var.private_subnet_cidr_block_1 # CIDR block for the private subnet 1
  availability_zone = var.availability_zone_private_1 # Private subnet 1 availability zone

  tags = {
    Name        = "${var.name_prefix}-private-subnet-1" # Dynamic name for private subnet 1
    Environment = var.environment                       # Environment tag for resource organization
  }
}

# Private subnet 2 configuration
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id                  # Link the private subnet to the VPC
  cidr_block        = var.private_subnet_cidr_block_2 # CIDR block for the private subnet 2
  availability_zone = var.availability_zone_private_2 # Private subnet 2 availability zone

  tags = {
    Name        = "${var.name_prefix}-private-subnet-2" # Dynamic name for private subnet 2
    Environment = var.environment                       # Environment tag for resource organization
  }
}