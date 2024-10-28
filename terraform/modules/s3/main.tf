# --- S3 Bucket for Terraform State --- #

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${lower(var.name_prefix)}-terraform-state-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-terraform-state"
    Environment = var.environment
  }
}

# --- Lifecycle Configuration for Terraform State Bucket --- #

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "retain-versioned-states"
    status = "Enabled"

    # Expiration settings for non-current versions
    filter {
      prefix = "" # Apply to all objects
    }

    noncurrent_version_expiration {
      noncurrent_days = 90 # Retain non-current versions for 90 days
    }
  }
}

# --- Versioning Configuration for Terraform State Bucket --- #

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- DynamoDB Table for Terraform State Locking --- #

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${lower(var.name_prefix)}-terraform-locks-${random_string.suffix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

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

resource "aws_s3_bucket" "wordpress_media" {
  bucket = "${lower(var.name_prefix)}-wordpress-media-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-media"
    Environment = var.environment
  }
}

# --- Versioning Configuration for WordPress Media Bucket --- #

resource "aws_s3_bucket_versioning" "wordpress_media_versioning" {
  bucket = aws_s3_bucket.wordpress_media.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- S3 Bucket for WordPress Scripts --- #

resource "aws_s3_bucket" "wordpress_scripts" {
  bucket = "${lower(var.name_prefix)}-wordpress-scripts-${random_string.suffix.result}"

  tags = {
    Name        = "${var.name_prefix}-wordpress-scripts"
    Environment = var.environment
  }
}

# --- Versioning Configuration for WordPress Scripts Bucket --- #

resource "aws_s3_bucket_versioning" "wordpress_scripts_versioning" {
  bucket = aws_s3_bucket.wordpress_scripts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- Random String for Unique Resource Names --- #
resource "random_string" "suffix" {
  length  = 5     # Length of the random string
  special = false # Disable special characters
  upper   = false # Disable uppercase letters
  lower   = true  # Enable lowercase letters
  numeric = true  # Enable numeric characters (replacing deprecated 'number')

  # Note: The 'number' argument is deprecated; using 'numeric' instead
}
