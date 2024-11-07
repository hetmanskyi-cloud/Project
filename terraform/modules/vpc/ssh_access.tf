# --- Security Group for SSH Access --- #
# This Security Group allows SSH access to EC2 instances for testing purposes.
# SSH access can be enabled or disabled using the 'allow_ssh_access' variable.

resource "aws_security_group" "ssh_sg" {
  name_prefix = "${var.name_prefix}-ssh-sg"
  description = "Security Group for SSH access to EC2 instances"
  vpc_id      = aws_vpc.vpc.id

  # --- Ingress Rules (Inbound Traffic) --- #

  # Allow inbound SSH traffic if allow_ssh_access is set to true
  dynamic "ingress" {
    for_each = var.allow_ssh_access ? [1] : []
    content {
      description = "Allow SSH access for testing purposes (can be disabled)"
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
    Name        = "${var.name_prefix}-ssh-sg"
    Environment = var.environment
  }
}
