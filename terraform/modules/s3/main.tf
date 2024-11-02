# --- S3 Bucket for Terraform State ---
# Bucket for storing Terraform state with versioning and lifecycle policies
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${lower(var.name_prefix)}-terraform-state-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-terraform-state"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for Terraform State Bucket ---
# Configures default server-side encryption for the Terraform state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AES-256 encryption
    }
  }
}

# --- Versioning Configuration for Terraform State Bucket ---
# Enables versioning on the Terraform state bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to maintain history of objects
  }
}

# --- DynamoDB Table for Terraform State Locking ---
# Creates a DynamoDB table to handle state locking for Terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${lower(var.name_prefix)}-terraform-locks-${random_string.suffix.result}"
  billing_mode = "PAY_PER_REQUEST" # Pay-per-request billing
  hash_key     = "LockID"

  # Enable server-side encryption for DynamoDB
  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.name_prefix}-terraform-locks"
    Environment = var.environment
  }
}

# --- S3 Bucket for WordPress Media ---
# Bucket for storing WordPress media files with encryption and versioning
resource "aws_s3_bucket" "wordpress_media" {
  bucket = "${lower(var.name_prefix)}-wordpress-media-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-media"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for WordPress Media Bucket ---
# Configures default server-side encryption for the WordPress media bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_media_encryption" {
  bucket = aws_s3_bucket.wordpress_media.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AES-256 encryption
    }
  }
}

# --- Versioning Configuration for WordPress Media Bucket ---
# Enables versioning for the WordPress media bucket to keep a history of object versions
resource "aws_s3_bucket_versioning" "wordpress_media_versioning" {
  bucket = aws_s3_bucket.wordpress_media.id
  versioning_configuration {
    status = "Enabled" # Enable versioning for object history
  }
}

# --- S3 Bucket for WordPress Scripts ---
# Bucket for storing setup scripts for WordPress with encryption and versioning
resource "aws_s3_bucket" "wordpress_scripts" {
  bucket = "${lower(var.name_prefix)}-wordpress-scripts-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-scripts"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for WordPress Scripts Bucket ---
# Configures default server-side encryption for the WordPress scripts bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_scripts_encryption" {
  bucket = aws_s3_bucket.wordpress_scripts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AES-256 encryption
    }
  }
}

# --- Versioning Configuration for WordPress Scripts Bucket ---
# Enables versioning for the WordPress scripts bucket to retain historical versions
resource "aws_s3_bucket_versioning" "wordpress_scripts_versioning" {
  bucket = aws_s3_bucket.wordpress_scripts.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to maintain object history
  }
}

# --- Random String for Unique Resource Names ---
# Generates a suffix to make bucket names globally unique
resource "random_string" "suffix" {
  length  = 5     # Length of the random string
  special = false # Disable special characters
  upper   = false # Disable uppercase letters
  lower   = true  # Enable lowercase letters
  numeric = true  # Enable numeric characters
}
