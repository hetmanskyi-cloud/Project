# Create IAM policy document for KMS permissions
data "aws_iam_policy_document" "vpc_flow_logs_kms_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    resources = [var.kms_key_arn]
  }
}

# Create CloudWatch log group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = {
    Name        = "${var.name_prefix}-flow-logs"
    Environment = var.environment
  }
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = var.flow_logs_role_arn # Use the role created in IAM module

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-log"
    Environment = var.environment
  }
}
