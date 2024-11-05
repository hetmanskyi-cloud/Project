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
