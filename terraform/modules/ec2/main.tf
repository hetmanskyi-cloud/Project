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

  # User data to execute the deploy_wordpress.sh script on instance launch
  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  # Configure Instance Metadata Service to require tokens
  metadata_options {
    http_tokens = "required" # Ensures only requests with a valid token can access metadata
  }

  # Network interfaces configuration
  network_interfaces {
    associate_public_ip_address = true # Assign a public IP address to instances
    delete_on_termination       = true # Remove network interface on termination
    security_groups = [
      aws_security_group.ec2_sg.id,     # SG for HTTP/HTTPS access
      aws_security_group.ssh_access.id, # SG for SSH access
      var.ssm_endpoint_sg_id            # SG for SSM access
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
  vpc_zone_identifier = var.subnet_ids          # Subnet IDs for Auto Scaling Group

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
  retention_in_days = 7                             # Retention policy for development environment
  kms_key_id        = var.kms_key_arn               # Use KMS key for log encryption
}
