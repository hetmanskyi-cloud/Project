# --- S3 Bucket for Terraform State --- #
# Bucket for storing Terraform state with versioning and lifecycle policies
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${lower(var.name_prefix)}-terraform-state-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-terraform-state"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for Terraform State Bucket --- #
# Configures server-side encryption with KMS for the Terraform state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"       # Use KMS for encryption
      kms_master_key_id = var.kms_key_arn # Reference KMS key for encryption
    }
  }
}

# --- Versioning Configuration for Terraform State Bucket --- #
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

  # Enable server-side encryption for DynamoDB with KMS key
  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn # KMS key for DynamoDB encryption
  }

  # Enable point-in-time recovery
  point_in_time_recovery {
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

# --- S3 Bucket for WordPress Media --- #
# Bucket for storing WordPress media files with encryption and versioning
resource "aws_s3_bucket" "wordpress_media" {
  bucket = "${lower(var.name_prefix)}-wordpress-media-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-media"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for WordPress Media Bucket --- #
# Configures server-side encryption with KMS for the WordPress media bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_media_encryption" {
  bucket = aws_s3_bucket.wordpress_media.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"       # Use KMS for encryption
      kms_master_key_id = var.kms_key_arn # Reference KMS key for encryption
    }
  }
}

# --- Versioning Configuration for WordPress Media Bucket --- #
# Enables versioning for the WordPress media bucket to keep a history of object versions
resource "aws_s3_bucket_versioning" "wordpress_media_versioning" {
  bucket = aws_s3_bucket.wordpress_media.id
  versioning_configuration {
    status = "Enabled" # Enable versioning for object history
  }
}

# --- S3 Bucket for WordPress Scripts --- #
# Bucket for storing setup scripts for WordPress with encryption and versioning
resource "aws_s3_bucket" "wordpress_scripts" {
  bucket = "${lower(var.name_prefix)}-wordpress-scripts-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-scripts"
    Environment = var.environment
  }
}

# --- Server-Side Encryption for WordPress Scripts Bucket --- #
# Configures server-side encryption with KMS for the WordPress scripts bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_scripts_encryption" {
  bucket = aws_s3_bucket.wordpress_scripts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"       # Use KMS for encryption
      kms_master_key_id = var.kms_key_arn # Reference KMS key for encryption
    }
  }
}

# --- Versioning Configuration for WordPress Scripts Bucket --- #
# Enables versioning for the WordPress scripts bucket to retain historical versions
resource "aws_s3_bucket_versioning" "wordpress_scripts_versioning" {
  bucket = aws_s3_bucket.wordpress_scripts.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to maintain object history
  }
}

# --- Public Access Block for Terraform State Bucket ---
# Block public access settings to ensure the Terraform state bucket is private
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true # Prevents public ACLs on objects
  block_public_policy     = true # Prevents the application of public bucket policies
  ignore_public_acls      = true # Ignores any public ACLs applied to objects
  restrict_public_buckets = true # Restricts the bucket to only private policies
}

# --- Public Access Block for WordPress Media Bucket ---
# Block public access settings to ensure the WordPress media bucket is private
resource "aws_s3_bucket_public_access_block" "wordpress_media_public_access" {
  bucket                  = aws_s3_bucket.wordpress_media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Public Access Block for WordPress Scripts Bucket ---
# Block public access settings to ensure the WordPress scripts bucket is private
resource "aws_s3_bucket_public_access_block" "wordpress_scripts_public_access" {
  bucket                  = aws_s3_bucket.wordpress_scripts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Logging Configuration for S3 Buckets --- #

# Terraform State Bucket Logging
resource "aws_s3_bucket_logging" "terraform_state_logging" {
  bucket = aws_s3_bucket.terraform_state.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/terraform_state/"
}

# WordPress Media Bucket Logging
resource "aws_s3_bucket_logging" "wordpress_media_logging" {
  bucket = aws_s3_bucket.wordpress_media.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/wordpress_media/"
}

# WordPress Scripts Bucket Logging
resource "aws_s3_bucket_logging" "wordpress_scripts_logging" {
  bucket = aws_s3_bucket.wordpress_scripts.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/wordpress_scripts/"
}

# --- S3 Bucket for Logging --- #
# Creates a bucket dedicated to storing access logs for other S3 buckets in the project
resource "aws_s3_bucket" "logging" {
  bucket = "${var.name_prefix}-logging-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-logging" # Dynamic name for the logging bucket
    Environment = var.environment              # Environment tag for tracking
  }
}

# --- Server-Side Encryption for Logging Bucket --- #
# Configures server-side encryption with KMS for the logging bucket to enhance security
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_encryption" {
  bucket = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"       # Use KMS for encryption
      kms_master_key_id = var.kms_key_arn # Reference KMS key for encryption
    }
  }
}

# --- Versioning Configuration for Logging Bucket --- #
# Enables versioning for the logging bucket to keep a history of log objects
resource "aws_s3_bucket_versioning" "logging_versioning" {
  bucket = aws_s3_bucket.logging.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to maintain object history
  }
}

# --- Public Access Block for Logging Bucket --- #
# Block public access settings to ensure the logging bucket is private
resource "aws_s3_bucket_public_access_block" "logging_public_access" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true # Prevents public ACLs on objects
  block_public_policy     = true # Prevents the application of public bucket policies
  ignore_public_acls      = true # Ignores any public ACLs applied to objects
  restrict_public_buckets = true # Restricts the bucket to only private policies
}

# --- Random String for Unique Resource Names --- #
# Generates a suffix to make the logging bucket name globally unique
resource "random_string" "suffix" {
  length  = 5     # Length of the random string
  special = false # Disable special characters
  upper   = false # Disable uppercase letters
  lower   = true  # Enable lowercase letters
  numeric = true  # Enable numeric characters
}
