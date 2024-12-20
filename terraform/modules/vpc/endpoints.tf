# --- Security Group for VPC Endpoints --- #

# Security Group for SSM Endpoint
resource "aws_security_group" "ssm_endpoint_sg" {
  name        = "${var.name_prefix}-ssm-endpoint-sg"     # Dynamic name for SSM Endpoint SG
  description = "Security Group for SSM endpoint access" # Description of the Security Group
  vpc_id      = aws_vpc.vpc.id                           # Attach to the created VPC

  # Ingress Rule: Allow HTTPS traffic within VPC for SSM Endpoint
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block] # Allow traffic from within the VPC CIDR
  }

  # Egress Rule: Allow HTTPS traffic to any destination
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Outbound to any destination, limited to HTTPS
  }

  tags = {
    Name        = "${var.name_prefix}-ssm-endpoint-sg" # Name for identifying SG
    Environment = var.environment                      # Environment tag
  }
}

# --- VPC Endpoints for SSM --- #

# Define the VPC Interface Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc.id                        # Attach to the created VPC
  service_name      = "com.amazonaws.${var.aws_region}.ssm" # SSM service endpoint
  vpc_endpoint_type = "Interface"                           # Use Interface type for SSM Endpoint
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id # Place in private subnets only
  ]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id] # Attach SG for SSM endpoint

  tags = {
    Name        = "${var.name_prefix}-ssm-endpoint"
    Environment = var.environment
  }
}

# Define the VPC Interface Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id            = aws_vpc.vpc.id                                # Attach to the created VPC
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages" # EC2 Messages service endpoint
  vpc_endpoint_type = "Interface"                                   # Use Interface type for EC2 Messages
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id # Place in private subnets only
  ]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id] # Attach SG for EC2 Messages

  tags = {
    Name        = "${var.name_prefix}-ec2messages-endpoint"
    Environment = var.environment
  }
}

# Define the VPC Interface Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.vpc.id                                # Attach to the created VPC
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages" # SSM Messages service endpoint
  vpc_endpoint_type = "Interface"                                   # Use Interface type for SSM Messages
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id # Place in private subnets only
  ]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id] # Attach SG for SSM Messages

  tags = {
    Name        = "${var.name_prefix}-ssmmessages-endpoint"
    Environment = var.environment
  }
}