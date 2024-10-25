output "vpc_flow_logs_role_arn" {
  description = "The ARN of the IAM role for VPC Flow Logs"
  value       = aws_iam_role.vpc_flow_logs_role.arn
}