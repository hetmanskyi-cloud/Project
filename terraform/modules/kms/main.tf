# --- KMS Key Configuration for CloudWatch Logs Encryption --- #

# Define the KMS key resource for encrypting CloudWatch logs and other services
resource "aws_kms_key" "log_encryption_key" {
  description         = "KMS key for encrypting CloudWatch logs and other resources"
  enable_key_rotation = true # Enable automatic key rotation for security

  # KMS key policy to control access permissions
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.aws_account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "logs.${var.aws_region}.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  }
  POLICY

  # Tags for the KMS key
  tags = {
    Name        = "${var.name_prefix}-kms-log-encryption-key" # Dynamic name for KMS key using prefix
    Environment = var.environment                             # Environment tag for resource tracking
  }
}