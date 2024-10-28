# VPC Module Configuration
module "vpc" {
  source = "./modules/vpc" # Path to the local VPC module directory

  # Defining VPC and subnet configuration through variables
  vpc_cidr_block              = var.vpc_cidr_block              # CIDR block for the VPC
  public_subnet_cidr_block    = var.public_subnet_cidr_block    # CIDR block for the public subnet
  private_subnet_cidr_block_1 = var.private_subnet_cidr_block_1 # CIDR block for the first private subnet
  private_subnet_cidr_block_2 = var.private_subnet_cidr_block_2 # CIDR block for the second private subnet
  availability_zone_public    = var.availability_zone_public    # Availability zone for the public subnet
  availability_zone_private_1 = var.availability_zone_private_1 # Availability zone for the first private subnet
  availability_zone_private_2 = var.availability_zone_private_2 # Availability zone for the second private subnet
  aws_account_id              = var.aws_account_id              # AWS Account ID for setting permissions and resources
  environment                 = var.environment                 # Environment tag (e.g., dev, prod)
  name_prefix                 = var.name_prefix                 # Prefix for resource naming

  # Providing KMS key ARN from the KMS module to enable encryption
  kms_key_arn = module.kms.kms_key_arn # KMS key ARN for log encryption
}

# KMS Module Configuration
module "kms" {
  source         = "./modules/kms"    # Path to the KMS module directory
  aws_region     = var.aws_region     # Specify the AWS region
  aws_account_id = var.aws_account_id # AWS Account ID for resource permissions
  environment    = var.environment    # Environment tag (e.g., dev, prod)
  name_prefix    = var.name_prefix    # Resource name prefix for identification
}

# CloudWatch Internet Monitor Module Configuration
module "internet_monitor" {
  source                  = "./modules/internet_monitor" # Path to the Internet Monitor module
  enable_internet_monitor = var.enable_internet_monitor  # Flag to enable or disable Internet Monitor
  name_prefix             = var.name_prefix              # Resource name prefix
  environment             = var.environment              # Environment tag for Internet Monitor
  aws_region              = var.aws_region               # AWS region for Internet Monitor
  vpc_id                  = module.vpc.vpc_id            # ID of the VPC to be monitored
  traffic_percentage      = var.traffic_percentage       # Percentage of traffic to monitor
}

# VPC Flow Logs Module Configuration
module "flow_logs" {
  source             = "./modules/flow_logs"               # Path to the new flow_logs module
  vpc_id             = module.vpc.vpc_id                   # Passing the VPC ID from the VPC module
  kms_key_arn        = module.kms.kms_key_arn              # Passing the KMS key ARN from the KMS module
  name_prefix        = var.name_prefix                     # Passing the name prefix variable from the main block
  environment        = var.environment                     # Passing the environment variable
  flow_logs_role_arn = module.flow_logs.flow_logs_role_arn # Flow Logs role ARN from the Flow Logs module
}

# --- EC2 Module Configuration --- #
module "ec2" {
  source              = "./modules/ec2"         # Path to the EC2 module
  ami_id              = var.ami_id              # AMI ID for EC2 instances
  instance_type       = var.instance_type       # EC2 instance type
  autoscaling_desired = var.autoscaling_desired # Desired number of instances in the Auto Scaling Group
  autoscaling_min     = var.autoscaling_min     # Minimum number of instances in the Auto Scaling Group
  autoscaling_max     = var.autoscaling_max     # Maximum number of instances in the Auto Scaling Group

  # Network configuration
  subnet_ids = [module.vpc.public_subnet_id] # ID of the public subnet for EC2
  vpc_id     = module.vpc.vpc_id             # ID of the VPC for EC2 deployment

  # WordPress database and Redis configuration
  db_name     = var.db_name        # Database name for WordPress
  db_user     = var.db_username    # Use db_username as the username for WordPress
  db_password = var.db_password    # Database password for WordPress
  db_host     = module.rds.db_host # Using db_host directly from RDS output
  db_port     = var.db_port        # Database port for MySQL RDS
  redis_host  = var.redis_host     # Redis host endpoint for WordPress caching
  redis_port  = var.redis_port     # Redis port for caching

  # Tags and environment information
  name_prefix = var.name_prefix # Prefix for resource naming
  environment = var.environment # Environment for resource tagging
}

# S3 Module Configuration
module "s3" {
  source      = "./modules/s3"  # Path to the local S3 module directory
  environment = var.environment # Environment tag (e.g., dev, prod)
  name_prefix = var.name_prefix # Prefix for resource naming
}

# --- RDS Module Configuration --- #
module "rds" {
  source      = "./modules/rds" # Path to the RDS module
  name_prefix = var.name_prefix # Prefix for resource names
  environment = var.environment # Environment tag for resources (e.g., dev, prod)

  # --- Database Configuration --- #
  allocated_storage = var.allocated_storage # Storage size for RDS instance
  instance_class    = var.instance_class    # RDS instance class
  engine            = var.engine            # Database engine type
  engine_version    = var.engine_version    # Database engine version
  username          = var.db_username       # Master username for the database
  password          = var.db_password       # Master password for the database
  db_name           = var.db_name           # Initial database name
  db_port           = var.db_port           # Database port for connectivity

  # --- Network Configuration --- #
  vpc_id                 = module.vpc.vpc_id                                                # VPC ID from the VPC module
  vpc_security_group_ids = [module.rds.rds_security_group_id]                               # RDS security group ID from module outputs
  subnet_ids             = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id] # Private subnets for RDS in different AZs
  allowed_cidr           = module.vpc.public_subnet_cidr_block                              # CIDR block for access control
  ec2_security_group_id  = module.ec2.ec2_security_group_id                                 # Security Group ID for EC2 access control

  # --- Backup and Replication Settings --- #
  backup_retention_period = var.backup_retention_period    # Retention period for RDS backups
  backup_window           = var.backup_window              # Preferred backup time window
  multi_az                = var.multi_az                   # Multi-AZ for high availability
  deletion_protection     = var.enable_deletion_protection # Deletion protection flag
  read_replica_count      = var.read_replica_count         # Number of read replicas for read scalability
}

