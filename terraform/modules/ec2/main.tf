# --- EC2 Launch Template Configuration --- #

# Define the EC2 launch template with AMI, instance type, and security settings
resource "aws_launch_template" "ec2" {
  name_prefix   = "${var.name_prefix}-lt" # Prefix for the launch template
  image_id      = var.ami_id              # AMI ID for the instances
  instance_type = var.instance_type       # Instance type specified in variables
  key_name      = var.ssh_key_name        # Name of the SSH key for accessing instances

  # Attach IAM instance profile for EC2 to assume necessary permissions
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  # User data for EC2 instance setup
  user_data = var.user_data
  # Ansible playbook (Uncomment this line if you prefer to use Ansible):
  # user_data = var.user_data

  # Configure Instance Metadata Service to require tokens
  metadata_options {
    http_tokens                 = "required" # Ensures only requests with a valid token can access metadata
    http_put_response_hop_limit = 2          # Limit the number of allowed HTTP put response hops
    http_endpoint               = "enabled"  # Enable HTTP access to metadata endpoint (default setting)
  }

  # Network interfaces configuration
  network_interfaces {
    associate_public_ip_address = true # Assign a public IP address to instances
    delete_on_termination       = true # Remove network interface on termination
    security_groups = [
      aws_security_group.ec2_sg.id, # SG for HTTP/HTTPS access
      var.ssm_endpoint_sg_id        # SG for SSM access
    ]
  }

  # Block device mappings for root volume with encryption enabled
  block_device_mappings {
    device_name = "/dev/xvda" # Root device name (varies by AMI)
    ebs {
      delete_on_termination = true            # Automatically delete the volume on instance termination
      encrypted             = true            # Enable encryption for the root EBS volume
      volume_size           = var.volume_size # Use volume_size variable from .tfvars
    }
  }

  # Tag specifications for instances created from this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.name_prefix}-ec2-{aws:InstanceId}" # Dynamic instance name with prefix and unique ID
      Environment = var.environment                           # Environment tag for organization
    }
  }
}

# --- EC2 Auto Scaling Group Configuration --- #

# Define the Auto Scaling Group with desired number of instances and subnet allocation
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity    = var.autoscaling_desired # Desired number of instances
  min_size            = var.autoscaling_min     # Minimum number of instances
  max_size            = var.autoscaling_max     # Maximum number of instances
  vpc_zone_identifier = var.subnet_ids          # List of subnet IDs for Auto Scaling Group across multiple availability zones

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }

  # Tags applied to all instances launched in the Auto Scaling Group
  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ec2-{aws:InstanceId}" # Name prefix and unique ID for instances
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment # Environment tag for instance identification
    propagate_at_launch = true
  }
}

# --- CloudWatch Alarms for Auto Scaling ---

# Alarm for scaling out (add instance when CPU > threshold)
resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_name          = "${var.name_prefix}-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.scale_out_cpu_threshold
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }
}

# Alarm for scaling in (remove instance when CPU < threshold)
resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_name          = "${var.name_prefix}-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.scale_in_cpu_threshold
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }
}

# --- Auto Scaling Policies ---

# Scale-out policy to add an instance when CPU utilization is high
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "${var.name_prefix}-scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.autoscaling_cooldown
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

# Scale-in policy to remove an instance when CPU utilization is low
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "${var.name_prefix}-scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.autoscaling_cooldown
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

# --- Data Source to Fetch EC2 Instance IDs --- #

# Fetch instances launched by the Auto Scaling Group
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ec2_asg.name]
  }
}

# --- CloudWatch Log Group for EC2 Instances --- #

# Define a CloudWatch Log Group for centralized logging of EC2 instances
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/${var.name_prefix}" # Log group name with project prefix
  retention_in_days = var.log_retention_in_days     # Retention policy for log retention, defined in variables
  kms_key_id        = var.kms_key_arn               # Use KMS key for log encryption
}
