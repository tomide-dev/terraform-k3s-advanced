# ── Provider ─────────────────────────────────────────────────

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ── S3 remote backend ───────────────────────────────────────
  # Replaces local terraform.tfstate with remote state in S3
  # DynamoDB handles state locking

  backend "s3" {
    bucket         = "terraform-state-terraform-lab"
    key            = "terraform-k3s/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Networking Module ─────────────────────────────────────────

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
}

# ── Compute Module ───────────────────────────────────────────

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = local.instance_type
  key_pair_name     = var.key_pair_name
  subnet_id         = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  volume_size       = local.volume_size
  install_k3s       = var.install_k3s
}