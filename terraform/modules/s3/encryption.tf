# --- Server-Side Encryption for Buckets --- #

# Encryption for Terraform State Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

# Encryption for WordPress Media Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_media_encryption" {
  bucket = aws_s3_bucket.wordpress_media.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

# Encryption for WordPress Scripts Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "wordpress_scripts_encryption" {
  bucket = aws_s3_bucket.wordpress_scripts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

# Encryption for Logging Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_encryption" {
  bucket = aws_s3_bucket.logging.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}
