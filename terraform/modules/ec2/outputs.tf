# --- EC2 Module Outputs ---

# Output the name of the Auto Scaling Group for EC2 instances
output "ec2_asg_name" {
  description = "The name of the Auto Scaling Group for EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.name
}

# Output the list of instance IDs in the Auto Scaling Group
output "ec2_instance_ids" {
  description = "The list of instance IDs in the Auto Scaling Group"
  value       = data.aws_instances.asg_instances.ids
}

# Output for public IP addresses of instances in Auto Scaling Group
output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances in the Auto Scaling Group"
  value       = data.aws_instances.asg_instances.public_ips
}

# Output the CloudWatch Log Group ARN for EC2 instances
output "ec2_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for EC2 instances"
  value       = aws_cloudwatch_log_group.ec2_log_group.arn
}

# Output the Security Group ID for EC2 instances
output "ec2_security_group_id" {
  description = "The ID of the Security Group for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}
