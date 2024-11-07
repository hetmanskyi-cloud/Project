# --- Internet Gateway Configuration --- #

# Create an Internet Gateway to provide internet access to public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id # Attach the Internet Gateway to the VPC

  tags = {
    Name        = "${var.name_prefix}-igw" # Dynamic name for the Internet Gateway
    Environment = var.environment          # Environment tag for resource organization
  }
}

# --- Public Route Table and Association --- #

# Define the public route table for routing internet-bound traffic in public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id # Reference the VPC by its ID

  # Route all internet-bound traffic through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"                 # Default route for all internet-bound traffic
    gateway_id = aws_internet_gateway.igw.id # Use the Internet Gateway for this route
  }

  tags = {
    Name        = "${var.name_prefix}-public-route-table" # Dynamic name for the route table
    Environment = var.environment                         # Environment tag for organization
  }
}

# Associate the public route table with public subnets for internet access
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id         # Reference the public subnet 1 by its ID
  route_table_id = aws_route_table.public_route_table.id # Associate the route table with public subnet 1
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id         # Reference the public subnet 2 by its ID
  route_table_id = aws_route_table.public_route_table.id # Associate the route table with public subnet 2
}

# --- Private Route Tables and Associations --- #

# Define a private route table for the first private subnet (no internet route)
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.vpc.id # Reference the VPC by its ID

  tags = {
    Name        = "${var.name_prefix}-private-route-table-1" # Dynamic name for private route table 1
    Environment = var.environment                            # Environment tag for organization
  }
}

# Associate the private route table 1 with the first private subnet
resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id           # Reference the first private subnet by its ID
  route_table_id = aws_route_table.private_route_table_1.id # Associate the route table with the first private subnet
}

# Define a private route table for the second private subnet (no internet route)
resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.vpc.id # Reference the VPC by its ID

  tags = {
    Name        = "${var.name_prefix}-private-route-table-2" # Dynamic name for private route table 2
    Environment = var.environment                            # Environment tag for organization
  }
}

# Associate the private route table 2 with the second private subnet
resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id           # Reference the second private subnet by its ID
  route_table_id = aws_route_table.private_route_table_2.id # Associate the route table with the second private subnet
}