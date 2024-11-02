# --- Bucket Policies, CORS, and Lifecycle Policies for S3 Buckets ---

# --- CORS Configuration for WordPress Media Bucket ---
# Configure CORS rules for the WordPress media bucket to allow cross-origin access
resource "aws_s3_bucket_cors_configuration" "wordpress_media_cors" {
  bucket = aws_s3_bucket.wordpress_media.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"] # Update to specific origin if needed
    max_age_seconds = 3000
  }
}

# --- Lifecycle Policy for WordPress Media Bucket ---
# Define a lifecycle policy to manage object versions in WordPress media bucket
resource "aws_s3_bucket_lifecycle_configuration" "wordpress_media_lifecycle" {
  bucket = aws_s3_bucket.wordpress_media.id

  rule {
    id     = "retain-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# --- Bucket Policy for WordPress Media Bucket ---
# Restrict access to only the AWS account ID for security
resource "aws_s3_bucket_policy" "wordpress_media_policy" {
  bucket = aws_s3_bucket.wordpress_media.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAccountAccess"
        Effect    = "Allow"
        Principal = { "AWS" : "arn:aws:iam::${var.aws_account_id}:root" }
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.wordpress_media.arn}/*"]
      }
    ]
  })
}

# --- Lifecycle Policy for WordPress Scripts Bucket ---
# Retain historical versions of setup scripts
resource "aws_s3_bucket_lifecycle_configuration" "wordpress_scripts_lifecycle" {
  bucket = aws_s3_bucket.wordpress_scripts.id

  rule {
    id     = "retain-script-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# --- Bucket Policy for Terraform State Bucket ---
# Restrict access to only the AWS account ID for security
resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAccountAccess"
        Effect    = "Allow"
        Principal = { "AWS" : "arn:aws:iam::${var.aws_account_id}:root" }
        Action    = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Resource  = ["${aws_s3_bucket.terraform_state.arn}", "${aws_s3_bucket.terraform_state.arn}/*"]
      }
    ]
  })
}

# --- Lifecycle Configuration for Terraform State Bucket ---
# Manages lifecycle settings to expire non-current object versions
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
