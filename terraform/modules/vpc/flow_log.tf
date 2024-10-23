# Create KMS key for encryption with key rotation enabled
resource "aws_kms_key" "log_encryption_key" {
  description         = "KMS key for encrypting CloudWatch logs"
  enable_key_rotation = true # Enable automatic key rotation every 365 days
  tags = {
    Name        = "vpc-log-kms-key"
    Environment = "dev"
  }
}

# Create CloudWatch log group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 365                                # Retain logs for 365 days (1 year) for Production
  kms_key_id        = aws_kms_key.log_encryption_key.arn # Add KMS key for encryption

  tags = {
    Name        = "vpc-flow-logs"
    Environment = "dev"
  }
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type         = "ALL" # Log all traffic (ingress and egress)
  vpc_id               = aws_vpc.dev_vpc.id
  log_destination_type = "cloud-watch-logs"

  tags = {
    Name        = "vpc-flow-log"
    Environment = "dev"
  }
}

