# --- Outputs for IAM Role and CloudWatch Log Group in VPC Flow Logs --- #

# Output the ARN of the IAM role for VPC Flow Logs
output "flow_logs_role_arn" {
  description = "The ARN of the IAM role for VPC Flow Logs" # ARN for referencing IAM role in other modules
  value       = aws_iam_role.vpc_flow_logs_role.arn
}

# Output the ARN of the CloudWatch Log Group for VPC Flow Logs
output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for VPC Flow Logs" # ARN for referencing Log Group in other modules
  value       = aws_cloudwatch_log_group.vpc_log_group.arn
}
