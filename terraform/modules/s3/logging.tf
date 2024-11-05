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

# Logging for Logging Bucket itself
resource "aws_s3_bucket_logging" "logging_bucket_logging" {
  bucket        = aws_s3_bucket.logging.id
  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${var.name_prefix}/logging/"
}
