# let's build a script to connect to AWS and download/setup all dependencies
# keyword: provider -> aws 

provider "aws" {
	region = "eu-west-1"
}

# then we will run terraform init (to initialise) in terminal/gitbash
# then we will move on to launch aws services

# lets launch an ec2 instance in eu-west-1 with ami-038d7b856fe7557b3 - ubuntu 16.04
# keyword: resource -> provide resource name and give specific details to service
# aws_ec2_instance, name, ami, type of instance, with/without ip - tags is keyword to name it

resource "aws_vpc" "terraform_vpc" {
	cidr_block = var.cidr_block
	instance_tenancy = "default"

	tags = {
		Name = var.vpc_name
	}
}

resource "aws_internet_gateway" "terraform_igw" {
	vpc_id = aws_vpc.terraform_vpc.id # takes id fomr created vpc above

	tags = {
		Name = var.igw_name
	}
}

resource "aws_route_table" "terraform_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
    
    tags = {
        Name = var.rt_name
    }
}

resource "aws_subnet" "terraform_public_sub" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = var.public_cidr
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.public_sub_name
    }
}

resource "aws_route_table_association" "terraform_rt_assoc" {
    subnet_id = aws_subnet.terraform_public_sub.id
    route_table_id = aws_route_table.terraform_rt.id
}

resource "aws_security_group" "app_sg" {
    vpc_id = aws_vpc.terraform_vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = [var.my_ip]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.app_sg_name
    }
}

resource "aws_instance" "app_instance" {
	key_name = var.aws_key_name # uses variable.tf
	ami = var.ami_id
  subnet_id = aws_subnet.terraform_public_sub.id
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = true

	tags = {
		Name = var.ec2_name
	}
}










