# --- Security Group for EC2 Instances --- #

# Define a Security Group for EC2 instances to allow HTTP, HTTPS, and SSM access
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.name_prefix}-ec2-sg"
  description = "Security group for EC2 instances running WordPress"
  vpc_id      = var.vpc_id

  # Ingress rule to allow HTTP access from any IP
  ingress {
    description = "Allow HTTP traffic from any IP address"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow HTTPS access from any IP
  ingress {
    description = "Allow HTTPS traffic from any IP address"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-ec2-sg"
    Environment = var.environment
  }
}

# --- Security Group for SSH Access --- #

# Define a Security Group specifically for SSH access on port 22
resource "aws_security_group" "ssh_access" {
  vpc_id      = var.vpc_id
  description = "Security group for SSH access"

  # Ingress rule to allow SSH access from any IP for testing
  # Recommended to restrict this to specific IPs for production
  ingress {
    description = "Allow SSH access from any IP address for testing purposes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-ssh-access"
    Environment = var.environment
  }
}
