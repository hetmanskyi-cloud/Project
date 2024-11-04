# --- Security Group for EC2 Instances --- #

# Define a Security Group for EC2 instances to allow HTTP, HTTPS, and SSM access
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.name_prefix}-ec2-sg"
  description = "Security group for EC2 instances running WordPress"
  vpc_id      = var.vpc_id

  # --- Ingress Rules (Inbound Traffic) --- #

  # Allow inbound HTTP traffic from any IP
  ingress {
    description = "Allow HTTP traffic from any IP address"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS traffic from any IP
  ingress {
    description = "Allow HTTPS traffic from any IP address"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Egress Rules (Outbound Traffic) --- #

  # Allow outbound HTTP traffic
  egress {
    description = "Allow outbound HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound HTTPS traffic
  egress {
    description = "Allow outbound HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-ec2-sg"
    Environment = var.environment
  }
}

# --- Security Group for SSH Access --- #

# Define a Security Group specifically for SSH access on port 22, restricted by allowed IPs
resource "aws_security_group" "ssh_access" {
  vpc_id      = var.vpc_id
  description = "Security group for SSH access"

  # --- Ingress Rules (Inbound Traffic) --- #

  # Allow inbound SSH access from specified IP ranges
  ingress {
    description = "Allow SSH access from specified IP ranges"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # --- Egress Rule for SSH --- #

  # Allow outbound SSH traffic
  egress {
    description = "Allow outbound SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-ssh-access"
    Environment = var.environment
  }
}
