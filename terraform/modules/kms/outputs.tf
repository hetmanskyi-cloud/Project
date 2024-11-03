# --- KMS Key Outputs --- #

# Output the ARN of the KMS key for use in other modules
output "kms_key_arn" {
  description = "The ARN of the general encryption KMS key for encryption"
  value       = aws_kms_key.general_encryption_key.arn
}
