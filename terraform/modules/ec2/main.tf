# --- EC2 Launch Template Configuration --- #

# Define the EC2 launch template with AMI, instance type, and tags
resource "aws_launch_template" "ec2" {
  name_prefix   = "${var.name_prefix}-lt"
  image_id      = var.ami_id        # AMI ID from dev.tfvars
  instance_type = var.instance_type # Instance type from dev.tfvars

  # User data to execute deploy_wordpress.sh script
  user_data = base64encode(file("${path.module}/deploy_wordpress.sh"))

  # Network interfaces configuration
  network_interfaces {
    associate_public_ip_address = true                           # Assign a public IP address
    delete_on_termination       = true                           # Delete network interface on termination
    security_groups             = [aws_security_group.ec2_sg.id] # Attach Security Group
  }

  # Tag specifications for instances created from this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.name_prefix}-ec2-{aws:InstanceId}" # Base name prefix with unique ID
      Environment = var.environment                           # Environment tag
    }
  }
}

# --- EC2 Auto Scaling Group Configuration --- #

# Define the Auto Scaling Group with the launch template and subnets
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity    = var.autoscaling_desired # Desired number of instances
  min_size            = var.autoscaling_min     # Minimum number of instances
  max_size            = var.autoscaling_max     # Maximum number of instances
  vpc_zone_identifier = var.subnet_ids          # Subnet IDs for Auto Scaling Group, public subnet

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }

  # Tags for instances launched in this Auto Scaling Group
  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ec2-{aws:InstanceId}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
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

# Define a CloudWatch Log Group for centralized log management
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/${var.name_prefix}"
  retention_in_days = 7 # Log retention policy for development environment
}
