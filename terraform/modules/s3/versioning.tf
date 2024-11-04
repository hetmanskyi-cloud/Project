# --- Versioning Configuration for Buckets --- #

# Versioning for Terraform State Bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to maintain history of objects
  }
}

# Versioning for WordPress Media Bucket
resource "aws_s3_bucket_versioning" "wordpress_media_versioning" {
  bucket = aws_s3_bucket.wordpress_media.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Versioning for WordPress Scripts Bucket
resource "aws_s3_bucket_versioning" "wordpress_scripts_versioning" {
  bucket = aws_s3_bucket.wordpress_scripts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Versioning for Logging Bucket
resource "aws_s3_bucket_versioning" "logging_versioning" {
  bucket = aws_s3_bucket.logging.id
  versioning_configuration {
    status = "Enabled"
  }
}
