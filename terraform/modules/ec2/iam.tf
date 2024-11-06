# --- IAM Role for EC2 with SSM Access --- #

# This IAM Role allows EC2 instances to access AWS SSM (Systems Manager)
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
# This policy provides the necessary permissions for the EC2 instance to use SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm_role_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --- IAM Instance Profile for EC2 Instances --- #
# The Instance Profile allows the IAM Role to be attached to EC2 instances for SSM access
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Name        = "${var.name_prefix}-ec2-instance-profile" # Instance profile name for clarity
    Environment = var.environment                           # Environment tag for resource management
  }
}
