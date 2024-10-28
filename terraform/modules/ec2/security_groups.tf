# --- Security Group for EC2 Instances --- #

# Define Security Group for EC2 with rules allowing HTTP access and open egress traffic
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.name_prefix}-ec2-sg"
  description = "Security group for EC2 instances running WordPress"
  vpc_id      = var.vpc_id # Using the passed VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access for ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
