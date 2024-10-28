# --- RDS Database Instance Configuration --- #

# Define the RDS database instance with dynamic engine and configurations
resource "aws_db_instance" "db" {
  identifier        = "${var.name_prefix}-db-${var.environment}" # Unique identifier for RDS instance
  allocated_storage = var.allocated_storage                      # Storage size in GB
  instance_class    = var.instance_class                         # RDS instance class
  engine            = var.engine                                 # Database engine (MySQL, PostgreSQL, etc.)
  engine_version    = var.engine_version                         # Database engine version
  username          = var.username                               # Master username
  password          = var.password                               # Master password
  db_name           = var.db_name                                # Initial database name
  multi_az          = var.multi_az                               # Multi-AZ deployment for high availability

  # Security and Networking
  vpc_security_group_ids = var.vpc_security_group_ids               # Security group IDs for access control
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name # Name of DB subnet group for RDS

  # Backup and Performance
  backup_retention_period = var.backup_retention_period # Retention period for backups
  backup_window           = var.backup_window           # Preferred backup time window

  # Enable or disable deletion protection based on environment
  deletion_protection = var.deletion_protection # Deletion protection for RDS

  tags = {
    Name        = "${var.name_prefix}-db" # Dynamic name for tagging
    Environment = var.environment         # Environment tag
  }
}

# --- DB Subnet Group Configuration --- #

# Define a DB subnet group for RDS to specify the private subnets for deployment
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.name_prefix}-db-subnet-group"          # Name for the DB subnet group
  description = "Subnet group for RDS ${var.engine} instance" # Description for the DB subnet group
  subnet_ids  = var.subnet_ids                                # Assign RDS to specific private subnets (e.g., Private Subnet 1)

  tags = {
    Name        = "${var.name_prefix}-db-subnet-group" # Tag with dynamic name
    Environment = var.environment                      # Environment tag for management
  }
}
