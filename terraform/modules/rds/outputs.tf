# --- RDS Module Outputs --- #

# Output the endpoint of the RDS database
output "db_host" {
  description = "The endpoint of the RDS database" # Database connection endpoint
  value       = aws_db_instance.db.endpoint        # Reference to the RDS endpoint
}

# Output the database name
output "db_name" {
  description = "The name of the RDS database" # Initial database name
  value       = var.db_name                    # Reference to the database name variable
}

# Output the master username for the database
output "db_username" {
  description = "The master username for the RDS database" # Database master username
  value       = var.username                               # Reference to the username variable
}

# Output the security group ID for RDS
output "rds_security_group_id" {
  description = "The ID of the security group for RDS access" # Security group for controlling RDS access
  value       = aws_security_group.rds_sg.id                  # Reference to the RDS security group ID
}
