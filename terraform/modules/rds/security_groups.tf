# --- RDS Security Group Configuration --- #

# Define a Security Group for RDS to control inbound and outbound traffic
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg-${var.environment}" # Dynamic name for RDS security group
  description = "Security group for RDS access"                # Description of the security group
  vpc_id      = var.vpc_id                                     # VPC ID where the security group is created

  # --- Ingress Rules --- #

  # Allow inbound traffic from EC2 instances in the specified security group
  ingress {
    from_port       = var.db_port # Database port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id] # Allow from EC2 security group
  }

  # Allow inbound traffic from specified CIDR blocks (e.g., for administrative access)
  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks # List of allowed CIDR blocks
  }

  # --- Egress Rules --- #

  # Allow all outbound traffic (adjust if needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Tags --- #

  tags = {
    Name        = "${var.name_prefix}-rds-sg-${var.environment}" # Tag for identifying the security group
    Environment = var.environment                                # Environment tag
  }
}
