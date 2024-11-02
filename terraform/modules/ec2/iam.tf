# --- IAM Role for EC2 with SSM Access --- #

# Define an IAM Role for EC2 instances to allow access to SSM
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-ec2-ssm-role" # Naming for easy identification
    Environment = var.environment                   # Environment tag for resource tracking
  }
}

# Attach the managed policy to the IAM Role to allow SSM access
resource "aws_iam_role_policy_attachment" "ec2_ssm_role_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --- IAM Instance Profile for EC2 Instances --- #

# Define an IAM Instance Profile to attach the IAM Role to EC2 instances
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Name        = "${var.name_prefix}-ec2-instance-profile" # Instance profile name for clarity
    Environment = var.environment                           # Environment tag for resource management
  }
}
