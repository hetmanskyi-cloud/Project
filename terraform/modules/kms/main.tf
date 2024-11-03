# --- General Encryption Key Configuration for CloudWatch Logs and S3 Buckets --- #

# Define a general KMS key resource to encrypt CloudWatch logs, S3 buckets, and other resources
resource "aws_kms_key" "general_encryption_key" {
  description         = "General KMS key for encrypting CloudWatch logs, S3 buckets, and other resources"
  enable_key_rotation = true # Enable automatic key rotation for added security

  # KMS key policy to control access permissions for services and root account
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
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  }
  POLICY

  # Tags for the general encryption key
  tags = {
    Name        = "${var.name_prefix}-general-encryption-key" # Dynamic name for the encryption key
    Environment = var.environment                             # Environment tag for tracking
  }
}
