# --- EC2 Module Outputs ---
# These outputs provide key information about the EC2 instances and related resources.
# Useful for integration with other modules, such as ALB, and for monitoring purposes.

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

# Output for private IP addresses of instances in Auto Scaling Group
output "ec2_instance_private_ips" {
  description = "Private IP addresses of EC2 instances in the Auto Scaling Group"
  value       = data.aws_instances.asg_instances.private_ips
}

# Output the CloudWatch Log Group ARN for EC2 instances
output "ec2_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for EC2 instances"
  value       = aws_cloudwatch_log_group.ec2_log_group.arn
}
