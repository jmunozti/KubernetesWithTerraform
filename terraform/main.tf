provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

module "vpc" {
  source              = "../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  tenancy             = var.tenancy
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  environment         = var.environment
}

module "bastion" {
  source            = "../modules/bastion"
  subnet_id         = module.vpc.public_subnet_id
  ssh_key           = var.ssh_key
  internal_networks = [var.private_subnet_cidr]
  environment       = var.environment
  ami_id            = data.aws_ami.ubuntu.id
}

module "asg" {
  source                      = "../modules/asg"
  vpc_id                      = module.vpc.vpc_id
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  ssh_key                     = var.ssh_key
  min_size                    = var.min_size
  max_size                    = var.max_size
  vpc_zone_identifier         = module.vpc.public_subnet_id
  health_check_type           = var.health_check_type
  internal_networks           = [var.private_subnet_cidr]
  environment                 = var.environment
  associate_public_ip_address = var.associate_public_ip_address
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "kubernetess-with-terraform-2020"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}
