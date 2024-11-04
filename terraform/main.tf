# --- VPC Module Configuration ---
# This module sets up the VPC, subnets, route tables, and related networking components.
module "vpc" {
  source = "./modules/vpc"

  # VPC CIDR block and subnet configurations
  vpc_cidr_block              = var.vpc_cidr_block
  allowed_ssh_cidr            = var.allowed_ssh_cidr
  public_subnet_cidr_block_1  = var.public_subnet_cidr_block_1
  public_subnet_cidr_block_2  = var.public_subnet_cidr_block_2
  private_subnet_cidr_block_1 = var.private_subnet_cidr_block_1
  private_subnet_cidr_block_2 = var.private_subnet_cidr_block_2

  # Availability zones for high availability
  availability_zone_public_1  = var.availability_zone_public_1
  availability_zone_public_2  = var.availability_zone_public_2
  availability_zone_private_1 = var.availability_zone_private_1
  availability_zone_private_2 = var.availability_zone_private_2

  # Region and account information
  region         = var.aws_region
  aws_account_id = var.aws_account_id

  # Security, monitoring and encryption
  kms_key_arn        = module.kms.kms_key_arn # KMS key ARN used for encryption of CloudWatch Logs
  flow_logs_role_arn = module.flow_logs.flow_logs_role_arn


  # General configuration and tagging
  environment = var.environment
  name_prefix = var.name_prefix
}

# --- KMS Module Configuration ---
# This module creates a KMS key for encrypting resources like CloudWatch Logs and EBS volumes.
module "kms" {
  source         = "./modules/kms"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  environment    = var.environment
  name_prefix    = var.name_prefix
}

# --- CloudWatch Internet Monitor Module Configuration ---
# This module sets up the Internet Monitor if enabled, to monitor network traffic and performance.
module "internet_monitor" {
  source                  = "./modules/internet_monitor"
  enable_internet_monitor = var.enable_internet_monitor
  name_prefix             = var.name_prefix
  environment             = var.environment
  aws_region              = var.aws_region
  vpc_id                  = module.vpc.vpc_id
  traffic_percentage      = var.traffic_percentage
}

# --- VPC Flow Logs Module Configuration ---
# This module configures VPC Flow Logs to capture network traffic logs and send them to CloudWatch Logs.
module "flow_logs" {
  source             = "./modules/flow_logs"
  vpc_id             = module.vpc.vpc_id
  kms_key_arn        = module.kms.kms_key_arn
  flow_logs_role_arn = module.flow_logs.flow_logs_role_arn
  name_prefix        = var.name_prefix
  environment        = var.environment
}

# --- S3 Module Configuration ---
# This module sets up S3 buckets for various purposes such as Terraform state storage.
module "s3" {
  source         = "./modules/s3"
  environment    = var.environment
  name_prefix    = var.name_prefix
  aws_account_id = var.aws_account_id
  kms_key_arn    = module.kms.kms_key_arn
}

# --- RDS Module Configuration ---
# This module sets up an RDS instance for the WordPress database.
module "rds" {
  source      = "./modules/rds"
  name_prefix = var.name_prefix
  environment = var.environment

  # Database configuration
  allocated_storage = var.allocated_storage
  instance_class    = var.instance_class
  engine            = var.engine
  engine_version    = var.engine_version
  username          = var.db_username
  password          = var.db_password
  db_name           = var.db_name
  db_port           = var.db_port

  # Network configuration
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
  ec2_security_group_id = module.ec2.ec2_security_group_id
  allowed_cidr_blocks   = [module.vpc.public_subnet_cidr_block_1, module.vpc.public_subnet_cidr_block_2]

  # Backup and replication settings
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  multi_az                = var.multi_az
  deletion_protection     = var.enable_deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  enable_monitoring       = var.enable_monitoring

  # KMS key for encryption
  kms_key_arn = module.kms.kms_key_arn
}

# --- EC2 Module Configuration ---
# This module sets up EC2 instances for running WordPress.
module "ec2" {
  source              = "./modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  autoscaling_desired = var.autoscaling_desired
  autoscaling_min     = var.autoscaling_min
  autoscaling_max     = var.autoscaling_max
  volume_size         = var.volume_size
  kms_key_arn         = module.kms.kms_key_arn

  # Network configuration
  subnet_ids                = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
  vpc_id                    = module.vpc.vpc_id
  ssm_endpoint_sg_id        = module.vpc.ssm_endpoint_sg_id
  public_subnet_cidr_blocks = [module.vpc.public_subnet_cidr_block_1, module.vpc.public_subnet_cidr_block_2]
  ssh_key_name              = var.ssh_key_name
  allowed_ssh_cidr          = var.allowed_ssh_cidr

  # WordPress database and Redis configuration
  db_name     = var.db_name
  db_user     = var.db_username
  db_password = var.db_password
  db_host     = module.rds.db_endpoint
  db_port     = var.db_port
  redis_host  = var.redis_host
  redis_port  = var.redis_port
  user_data   = var.user_data != "" ? base64encode(var.user_data) : (var.ansible_playbook_user_data != "" ? base64encode(var.ansible_playbook_user_data) : null)

  # Tags and environment information
  name_prefix = var.name_prefix
  environment = var.environment
}