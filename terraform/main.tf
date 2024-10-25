module "vpc" {
  source = "./modules/vpc" # Reference to the local vpc module directory

  # Passing variables to the VPC module
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_cidr_block    = var.public_subnet_cidr_block
  private_subnet_cidr_block_1 = var.private_subnet_cidr_block_1
  private_subnet_cidr_block_2 = var.private_subnet_cidr_block_2
  availability_zone_public    = var.availability_zone_public
  availability_zone_private_1 = var.availability_zone_private_1
  availability_zone_private_2 = var.availability_zone_private_2
  aws_account_id              = var.aws_account_id
  environment                 = var.environment
  name_prefix                 = var.name_prefix

  # Passing ARN role to vpc module
  flow_logs_role_arn = module.iam.vpc_flow_logs_role_arn

  # Passing the KMS key ARN from the kms module
  kms_key_arn = module.kms.kms_key_arn
}

module "kms" {
  source         = "./modules/kms"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  environment    = var.environment
  name_prefix    = var.name_prefix
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = var.name_prefix
}
