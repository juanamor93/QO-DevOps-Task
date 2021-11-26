terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "es-terraform-state-juanam"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  } 

}
# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "es-terraform-state-juanam" {
 bucket = "es-terraform-state-juanam"
 acl    = "private"

 versioning {
   enabled = true
 }
}
# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
} 
output "vpc_id" {
    value = module.vpc.vpc_id
} 
# EC2 Module 
module "ec2" {
  source = "./modules/ec2"
} 