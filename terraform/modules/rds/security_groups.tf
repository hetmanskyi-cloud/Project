# --- RDS Security Group Configuration --- #

# Define a Security Group for RDS to control inbound and outbound traffic
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg-${var.environment}" # Dynamic name for RDS security group
  description = "Security group for RDS access"                # Description of the security group
  vpc_id      = var.vpc_id                                     # VPC ID where the security group is created

  # --- Ingress Rules --- #

  # Combined Rule: Allow inbound traffic on the database port from the specified CIDR blocks
  ingress {
    description = "Allow inbound DB traffic from EC2 instances and allowed CIDR blocks"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # --- Egress Rules --- #

  # Rule: Allow outbound traffic on the database port to the EC2 security group for application access
  egress {
    description = "Allow outbound DB traffic to EC2 instances"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # --- Tags --- #

  tags = {
    Name        = "${var.name_prefix}-rds-sg-${var.environment}" # Tag for identifying the security group
    Environment = var.environment                                # Environment tag
  }
}