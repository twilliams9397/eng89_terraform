# contains all VPC related instructions - VPC and subnets

resource "aws_vpc" "terraform_vpc" {
  # creating vpc with chosen cidr
  cidr_block = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "terraform_public_sub" {
    vpc_id = aws_vpc.terraform_vpc.id
    # uses chosen cidr for public subnet
    cidr_block = var.public_cidr
    # gives subnet public ip
    map_public_ip_on_launch = "true"
    # chooses aws availability zone
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.public_sub_name
    }
}

resource "aws_subnet" "terraform_private_sub" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = var.private_cidr
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1a"
  tags = {
    Name = var.private_sub_name
  }
}