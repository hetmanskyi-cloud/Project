# --- Security Group for EC2 Instances --- #
# This Security Group manages access for EC2 instances running WordPress.
# It allows HTTP and HTTPS access from any IP.
# SSH access can be managed through an optional rule controlled by a variable.

resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.name_prefix}-ec2-sg"
  description = "Security Group for EC2 instances running WordPress"
  vpc_id      = var.vpc_id # Associate with the specified VPC

  # --- Ingress Rules (Inbound Traffic) --- #

  # Allow inbound HTTP traffic from any IP address
  ingress {
    description = "Allow HTTP traffic from any IP address"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS traffic from any IP address
  ingress {
    description = "Allow HTTPS traffic from any IP address"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access if enabled
  dynamic "ingress" {
    for_each = var.allow_ssh_access ? [1] : []
    content {
      description = "Allow SSH access for management purposes"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # --- Egress Rules (Outbound Traffic) --- #

  # Allow all outbound traffic
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
