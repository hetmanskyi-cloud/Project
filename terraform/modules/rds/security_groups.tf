# --- RDS Security Group Configuration --- #
resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.name_prefix}-rds-sg"     # Dynamic name prefix for RDS SG
  description = "Security group for RDS access" # Security group for RDS instances
  vpc_id      = var.vpc_id                      # VPC ID for the RDS instance

  # --- Ingress Rules --- #
  ingress {
    from_port       = var.db_port # Database port for inbound access
    to_port         = var.db_port # Database port for inbound access
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id] # Allow access from EC2 security group
    cidr_blocks     = [var.allowed_cidr]          # CIDR blocks for access control
  }

  # --- Egress Rules --- #
  egress {
    from_port   = 0 # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Tags --- #
  tags = {
    Name        = "${var.name_prefix}-rds-sg" # Tag for identifying RDS SG
    Environment = var.environment             # Environment tag
  }
}
