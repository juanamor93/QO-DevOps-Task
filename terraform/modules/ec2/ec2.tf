# Configure S3 Backend
terraform {
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
# VPC Remote state 
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
    bucket = "es-terraform-state-juanam"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    }
} 
# Variables
variable "ami" {
  type = map

  default = {
    "eu-west-2" = "ami-0fdf70ed5c34c5f52"
  }
}

variable "instance_count" {
  default = "3"
}

variable "instance_type" {
  default = "t3.small"
}

variable "aws_region" {
  default = "eu-west-2"
} 
variable "azs" {
	type = list
	default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

/*
output "ec2_id" {
  value = aws_instance.es_instance[count.index]
} */
# Production EC2 Instance Security Group
/*resource "aws_security_group" "es_sg"  {
  name = "es_sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  count = var.instance_count
    


     ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

tags = {
    Name = "es_sg${count.index + 1}"
  }
} */

# Instance Elastic IP
resource "aws_eip" "es_eip" {
  count         = var.instance_count
  instance = aws_instance.es_instance[count.index].id 
  vpc = true

  tags = {
    Name = "es_eip${count.index + 1}"
  }
} 

# AWS Key Pair
resource "aws_key_pair" "qo-test" {
  key_name   = "qo-test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRiLo/D2PbJxyUMElVxktouwh/1azk0WXYERuJ3Ui7O8+jpyAcBvKuLDeuvU5tODmE2PIP/SY5qAsWa0NbWm3MCvqVF8dIuz2qBmqWd0LQe92hhAQdN73zKMd/AxFo99AkCSsjQlPh8bff4dK2NRm1hT8Coa2qRrM5ooV65n70Tb/TBtMs9WPw4fqMZoMd6oPnygb4l2j4oN4sCdn5iaf4j42oF//2noys4ynlYo0AF3158i6PmuDntqaJDL3gTCa75G+tQTqEmFrqV/hhxgIlCV4dZ+fVJYIXGDuU7lmVtALz+wZ0yYAQVKGQJ8WIh95uObmYEQVwtu8r/Gy+FoD5"
}
# AWS Instances
resource "aws_instance" "es_instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.qo-test.key_name
  associate_public_ip_address = true
  availability_zone = element(var.azs,count.index)
 # vpc_security_group_ids = [aws_security_group.es_sg[count.index].id]
  #vpc_security_group_ids = [aws_security_group.es_sg.id]

  tags = {
    Name  = "es-${count.index + 1}"
    
  }
}