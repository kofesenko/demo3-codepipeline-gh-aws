terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-rndcharskf"
    key            = "staging/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    profile        = "terraform_admin"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = "terraform_admin"
}

module "vpc" {
  source = "./modules/vpc"

  environment_name = var.environment_name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets

  additional_tags = {
    Environment = "Staging"
    Owner       = "KF"
  }
}

module "alb" {
  source = "./modules/alb"

  private_subnets_id   = module.vpc.private_subnets_id
  public_subnets_id    = module.vpc.public_subnets_id
  vpc_id               = module.vpc.vpc_id
  sg_alb_ingress_ports = var.sg_alb_ingress_ports
  depends_on           = [module.vpc]
}

module "asg" {
  source = "./modules/asg"

  environment_name     = var.environment_name
  private_subnets_id   = module.vpc.private_subnets_id
  public_subnets_id    = module.vpc.public_subnets_id
  vpc_id               = module.vpc.vpc_id
  target_group_arns    = module.alb.target_group_arns
  alb_sg               = module.alb.alb_sg
  sg_asg_ingress_ports = var.sg_asg_ingress_ports
  instance_type        = var.instance_type
  ecs_cluster_name     = module.ecs.cluster_name
  depends_on           = [module.vpc, module.alb, module.ecs]
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source            = "./modules/ecs"
  ecr_url           = module.ecr.ecr_url
  target_group_arns = module.alb.target_group_arns
  container_port    = var.container_port
  depends_on        = [module.ecr, module.vpc]
}

module "codepipeline" {
  source                 = "./modules/codepipeline"
  ecr_url                = module.ecr.ecr_url
  ecs_cluster_name       = module.ecs.cluster_name
  ecs_service_name       = module.ecs.service_name
  codebuild_project_name = module.codebuild.codebuild_project_name
  environment_name       = var.environment_name
  artifacts_bucket_name  = var.artifacts_bucket_name
  ghrepo                 = var.ghrepo
  branch                 = var.branch
  region                 = var.region
  image_tag              = var.image_tag
  container_name         = var.container_name
  depends_on             = [module.ecr, module.ecs, module.codebuild]
}

module "codebuild" {
  source           = "./modules/codebuild"
  environment_name = var.environment_name
}