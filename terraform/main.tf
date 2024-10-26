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
