# --- S3 Bucket Outputs --- #

# Output the ARN of the Terraform state bucket
output "terraform_state_bucket_arn" {
  description = "The ARN of the S3 bucket for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.arn
}

# Output the DynamoDB table name for Terraform state locking
output "terraform_locks_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

# Output the ARN of the WordPress media bucket
output "wordpress_media_bucket_arn" {
  description = "The ARN of the S3 bucket for WordPress media storage"
  value       = aws_s3_bucket.wordpress_media.arn
}

# Output the ARN of the WordPress scripts bucket
output "wordpress_scripts_bucket_arn" {
  description = "The ARN of the S3 bucket for WordPress setup scripts"
  value       = aws_s3_bucket.wordpress_scripts.arn
}
