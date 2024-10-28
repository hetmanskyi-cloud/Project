# --- IAM Policies for VPC Flow Logs --- #

# Create IAM policy document for assume role
data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"] # Allow VPC Flow Logs service to assume role
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM policy document for KMS permissions for VPC Flow Logs
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
    resources = [var.kms_key_arn] # Restrict permissions to specified KMS key
  }
}

# --- IAM Role and Policies --- #

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "${var.name_prefix}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-logs-role"
    Environment = var.environment
  }
}

# Attach the CloudWatchLogsFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_cloudwatch_policy" {
  role       = aws_iam_role.vpc_flow_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Attach custom KMS policy to IAM Role for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name   = "${var.name_prefix}-vpc-flow-logs-policy"
  role   = aws_iam_role.vpc_flow_logs_role.id
  policy = data.aws_iam_policy_document.vpc_flow_logs_kms_policy.json
}

# --- CloudWatch Log Group for VPC Flow Logs --- #

# CloudWatch log group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 7               # Log retention policy for development environment
  kms_key_id        = var.kms_key_arn # Enable encryption with specified KMS key

  tags = {
    Name        = "${var.name_prefix}-flow-logs"
    Environment = var.environment
  }
}

# --- VPC Flow Log Configuration --- #

# VPC Flow Log configuration to send logs to CloudWatch
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type         = "ALL"      # Log all traffic (ingress and egress)
  vpc_id               = var.vpc_id # VPC ID for which logs are enabled
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = var.flow_logs_role_arn # Use IAM role ARN from IAM module

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-log"
    Environment = var.environment
  }
}

# --- CloudWatch Log Group Permissions Policy --- #

# IAM Policy Document for CloudWatch Log Group permissions
data "aws_iam_policy_document" "vpc_flow_logs_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"] # Essential CloudWatch actions
    resources = ["${aws_cloudwatch_log_group.vpc_log_group.arn}:*"]
  }
}
