# --- KMS Key Outputs --- #

# Output the ARN of the KMS key
output "kms_key_arn" {
  description = "The ARN of the KMS key"           # Description of the output for reference
  value       = aws_kms_key.log_encryption_key.arn # Reference to the ARN of the KMS key
}