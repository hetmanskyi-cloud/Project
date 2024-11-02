# --- IAM Policies for VPC Flow Logs --- #

# Create IAM policy document to allow the VPC Flow Logs service to assume role
data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM policy document for KMS permissions required by VPC Flow Logs
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
    resources = [var.kms_key_arn]
  }
}

# --- IAM Role and Policies --- #

# Create IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "${var.name_prefix}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-logs-role"
    Environment = var.environment
  }
}

# Attach the CloudWatchLogsFullAccess policy to enable CloudWatch access
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

# Create CloudWatch log group to store VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 7
  kms_key_id        = var.kms_key_arn

  tags = {
    Name        = "${var.name_prefix}-flow-logs"
    Environment = var.environment
  }

  # Lifecycle configuration to allow forced deletion
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [retention_in_days, kms_key_id]
  }

  # Dependency on IAM Role and Policy to ensure proper deletion
  depends_on = [
    aws_iam_role.vpc_flow_logs_role,
    aws_iam_role_policy_attachment.vpc_flow_logs_cloudwatch_policy
  ]
}

# --- VPC Flow Log Configuration --- #

# Configure VPC Flow Log to send logs to CloudWatch
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn

  lifecycle {
    prevent_destroy = false
  }

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
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.vpc_log_group.arn}:*"]
  }
}
