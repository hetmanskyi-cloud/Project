# --- KMS Key Configuration for CloudWatch Logs Encryption --- #

# Define the KMS key resource for CloudWatch logs encryption and other services
resource "aws_kms_key" "log_encryption_key" {
  description         = "KMS key for encrypting CloudWatch logs and other services"
  enable_key_rotation = true # Enable key rotation for added security

  # Define the KMS key policy to control access permissions
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

  # Tags for resource identification and management
  tags = {
    Name        = var.kms_key_name # Dynamic name for the KMS key
    Environment = var.environment  # Environment tag for resource tracking
  }
}