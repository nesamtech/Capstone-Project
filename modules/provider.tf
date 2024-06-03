terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10.0"
    }
  }
}

provider "aws" {
  region  = var.region
}

# Create vpc
module "vpc" {
  source                      = "./modules/vpc"
  region                      = var.region
  project_name                = var.project_name
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr 
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_subnet_az1_cidr     = var.private_subnet_az1_cidr 
  private_subnet_az2_cidr     = var.private_subnet_az1_cidr
  private_rds_subnet_az1_cidr = var.private_rds_subnet_az1_cidr
  private_rds_subnet_az2_cidr = var.private_rds_subnet_az2_cidr
  public_subnet1_id           = var.public_subnet1_id
  public_subnet2_id           = var.public_subnet2_id
  internet_gateway            = var.internet_gateway
  private_subnet1_id          = var.private_subnet1_id
  private_subnet2_id          = var.private_subnet2_id
  private_rds_subnet_az1_id   = var.private_rds_subnet_az1_id
  private_rds_subnet_az2_id   = var.private_rds_subnet_az2_id
  launch_template_name        = var.launch_template_name
}