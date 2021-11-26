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
# Variables
variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "subnets_cidr" {
	type = list
	default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
	type = list
	default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
# Outputs
output "vpc_id" {
  value = aws_vpc.es_vpc.id
  description = "ID for VPC"
} 
#VPC
resource "aws_vpc" "es_vpc" {
  cidr_block = "10.0.0.0/16"
  
}
# Internet Gateway
resource "aws_internet_gateway" "es_ig" {
  vpc_id = aws_vpc.es_vpc.id

  tags = {

    Name = "es_ig"
  }
}
# Public Subnets
resource "aws_subnet" "es_subnet" {
  count = length(var.subnets_cidr)
  vpc_id     = aws_vpc.es_vpc.id
  cidr_block = element(var.subnets_cidr,count.index)
  depends_on = [aws_internet_gateway.es_ig]
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "es_subnet-${count.index+1}"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "es_public_rt" {
  vpc_id = aws_vpc.es_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.es_ig.id
  }
  tags = {
    Name = "es_publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "es" {
  count = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.es_subnet.*.id,count.index)
  route_table_id = aws_route_table.es_public_rt.id
}






