# --- RDS Security Group Configuration --- #

# Define a Security Group for RDS to control inbound and outbound traffic
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg-${var.environment}" # Dynamic name for RDS security group
  description = "Security group for RDS access"                # Description of the security group
  vpc_id      = var.vpc_id                                     # VPC ID where the security group is created

  # --- Ingress Rules --- #

  # Rule: Allow inbound traffic on the database port from EC2 instances in the specified security group
  ingress {
    description = "Allow inbound DB traffic from EC2 instances"
    from_port   = var.db_port # Database port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks # Allow from EC2 security group
  }

  # Rule: Allow inbound traffic on the database port from specific CIDR blocks for administrative access
  ingress {
    description = "Allow inbound DB traffic from allowed CIDR blocks"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks # List of allowed CIDR blocks
  }

  # --- Egress Rules --- #

  # Rule: Allow outbound traffic on the database port to the EC2 security group for application access
  egress {
    description = "Allow outbound DB traffic to EC2 instances"
    from_port   = var.db_port # Database port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks # Restrict egress to only the EC2 security group for application traffic
  }

  # --- Tags --- #

  tags = {
    Name        = "${var.name_prefix}-rds-sg-${var.environment}" # Tag for identifying the security group
    Environment = var.environment                                # Environment tag
  }
}
