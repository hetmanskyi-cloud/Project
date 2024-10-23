# Initialize the VPC module from the local directory
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
}
# Trigger GitHub Actions