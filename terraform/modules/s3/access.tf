# --- Public Access Block for Buckets --- #

# Public Access Block for Terraform State Bucket
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Public Access Block for WordPress Media Bucket
resource "aws_s3_bucket_public_access_block" "wordpress_media_public_access" {
  bucket                  = aws_s3_bucket.wordpress_media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Public Access Block for WordPress Scripts Bucket
resource "aws_s3_bucket_public_access_block" "wordpress_scripts_public_access" {
  bucket                  = aws_s3_bucket.wordpress_scripts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Public Access Block for Logging Bucket
resource "aws_s3_bucket_public_access_block" "logging_public_access" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Logging Configuration for Buckets --- #

# Logging for Terraform State Bucket
resource "aws_s3_bucket_logging" "terraform_state_logging" {
  bucket        = aws_s3_bucket.terraform_state.id
  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/terraform_state/"
}

# Logging for WordPress Media Bucket
resource "aws_s3_bucket_logging" "wordpress_media_logging" {
  bucket        = aws_s3_bucket.wordpress_media.id
  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/wordpress_media/"
}

# Logging for WordPress Scripts Bucket
resource "aws_s3_bucket_logging" "wordpress_scripts_logging" {
  bucket        = aws_s3_bucket.wordpress_scripts.id
  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/wordpress_scripts/"
}
